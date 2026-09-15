#!/bin/bash
#
# Build the patched YAOS plugin from the fork branch (and optionally deploy the
# patched server, or publish a GitHub release for BRAT on mobile).
#
#   build.sh [build] [--deploy-server]  clone FORK_BRANCH, build, copy into the
#                                       profile (obsidian/default/plugins/yaos)
#   build.sh check                      is upstream ahead of the branch's base tag?
#                                       exit 0 = current, 10 = rebase needed
#                                       (prints "clean" or the conflicting files),
#                                       1 = could not check
#   build.sh update                     rebase FORK_BRANCH onto upstream's latest
#                                       tag, push, then build. Stops on conflict.
#   build.sh release                    build, then publish a GitHub release on the
#                                       fork tagged <upstream>-og.<n> with
#                                       main.js / manifest.json / styles.css.
#                                       Phone installs it with BRAT by exact tag.
#
# The manifest keeps upstream's version so Obsidian's store updater stays quiet;
# provenance lives in the .patched marker next to the built bundle.
#
# After --deploy-server, restart the YAOS plugin on EVERY device: a Worker
# redeploy leaves existing sync sockets half-dead (learned 2026-09-14).

set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd -P)"
DOTFILES="$(cd "$here/../../.." && pwd -P)"
PROFILE_PLUGIN="$DOTFILES/obsidian/default/plugins/yaos"
FORK="${YAOS_FORK:-mrilikecoding/og-cloud}"
FORK_BRANCH="${YAOS_FORK_BRANCH:-main}"
UPSTREAM="kavinsood/yaos"
API_LATEST="https://api.github.com/repos/$UPSTREAM/releases/latest"
WORK="${YAOS_BUILD_DIR:-$HOME/.cache/obsidian-profile/og-cloud}"

cmd="${1:-build}"; shift || true
deploy=0
for a in "$@"; do case "$a" in --deploy-server) deploy=1 ;; *) echo "unknown option: $a" >&2; exit 2 ;; esac; done

latest_upstream_tag() {
  curl -fsS --max-time 8 -A 'obsidian-profile' "$API_LATEST" \
    | python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"].lstrip("v"))'
}

# Clone (or refresh) the fork checkout and fetch upstream tags.
sync_checkout() {
  if [ -d "$WORK/.git" ]; then
    git -C "$WORK" fetch -q origin
    git -C "$WORK" remote get-url upstream >/dev/null 2>&1 || git -C "$WORK" remote add upstream "https://github.com/$UPSTREAM.git"
    git -C "$WORK" fetch -q upstream --tags
    git -C "$WORK" checkout -q "$FORK_BRANCH"
    git -C "$WORK" reset -q --hard "origin/$FORK_BRANCH"
  else
    mkdir -p "$(dirname "$WORK")"
    git clone -q --branch "$FORK_BRANCH" "https://github.com/$FORK.git" "$WORK"
    git -C "$WORK" remote add upstream "https://github.com/$UPSTREAM.git"
    git -C "$WORK" fetch -q upstream --tags
  fi
}

# The upstream tag the branch is currently based on: the newest tag reachable
# from the branch that is not one of our own commits.
base_tag() {
  git -C "$WORK" describe --tags --abbrev=0 --match '[0-9]*' "$(git -C "$WORK" merge-base "$FORK_BRANCH" upstream/main 2>/dev/null || echo "$FORK_BRANCH")"
}

do_check() {
  sync_checkout
  local base lat
  base="$(base_tag)"
  lat="$(latest_upstream_tag)" || { echo "yaos: could not reach GitHub to check upstream releases" >&2; return 1; }
  if [ "$base" = "$lat" ]; then
    echo "yaos: $FORK_BRANCH is based on upstream $base (latest)"
    return 0
  fi
  # Dry-run the rebase in a scratch worktree so the real checkout is untouched.
  local tmp; tmp="$(mktemp -d)"
  git -C "$WORK" worktree add -q "$tmp" "$FORK_BRANCH" 2>/dev/null
  local verdict
  if git -C "$tmp" -c advice.detachedHead=false rebase -q "$lat" >/dev/null 2>&1; then
    verdict="rebase applies cleanly"
  else
    verdict="rebase CONFLICTS in: $(git -C "$tmp" diff --name-only --diff-filter=U | tr '\n' ' ')"
    git -C "$tmp" rebase --abort >/dev/null 2>&1 || true
  fi
  git -C "$WORK" worktree remove --force "$tmp" >/dev/null 2>&1 || rm -rf "$tmp"
  echo "yaos: upstream $lat available (branch based on $base) — $verdict. Run: $here/build.sh update"
  return 10
}

do_build() {
  sync_checkout
  local base; base="$(base_tag)"
  echo "== yaos: building $FORK@$FORK_BRANCH (based on upstream $base, head $(git -C "$WORK" rev-parse --short HEAD))"
  ( cd "$WORK" && npm ci --silent && npm run build --silent )

  echo "== installing into profile: $PROFILE_PLUGIN"
  mkdir -p "$PROFILE_PLUGIN"
  cp "$WORK/main.js" "$WORK/manifest.json" "$WORK/styles.css" "$PROFILE_PLUGIN/"
  {
    echo "upstream=$base"
    echo "fork=$FORK@$FORK_BRANCH"
    echo "commit=$(git -C "$WORK" rev-parse --short HEAD)"
    echo "built=$(date -u +%Y-%m-%dT%H:%M:%SZ)"
  } > "$PROFILE_PLUGIN/.patched"
  cat "$PROFILE_PLUGIN/.patched"

  if [ "$deploy" = 1 ]; then
    echo "== deploying patched server"
    ( cd "$WORK/server" && npm ci --silent && wrangler deploy )
    echo "!! Now restart the YAOS plugin on every device (Mac: toggle plugin; phone: force-quit Obsidian)."
  fi
  echo "== done. Next: obsidian-profile sync (copies the bundle into registered vaults), then reload the plugin."
}

do_update() {
  sync_checkout
  local lat; lat="$(latest_upstream_tag)" || { echo "could not determine latest upstream release" >&2; exit 1; }
  echo "== rebasing $FORK_BRANCH onto upstream $lat"
  if ! git -C "$WORK" rebase "$lat"; then
    echo "!! rebase stopped on conflicts in $WORK — resolve, 'git rebase --continue', then: git push --force-with-lease && $0 build" >&2
    exit 1
  fi
  git -C "$WORK" push -q --force-with-lease origin "$FORK_BRANCH"
  do_build
}

do_release() {
  do_build
  local base n tag; base="$(base_tag)"
  n=$(( $(gh release list --repo "$FORK" --limit 100 --json tagName --jq "[.[] | select(.tagName | startswith(\"$base-og.\"))] | length") + 1 ))
  tag="$base-og.$n"
  echo "== publishing release $tag on $FORK"
  gh release create "$tag" --repo "$FORK" --target "$FORK_BRANCH" --title "YAOS $tag" \
    --notes "Patched build of upstream $base from branch $FORK_BRANCH ($(git -C "$WORK" rev-parse --short HEAD)). Install on mobile with BRAT: add beta plugin $FORK, frozen at $tag." \
    "$PROFILE_PLUGIN/main.js" "$PROFILE_PLUGIN/manifest.json" "$PROFILE_PLUGIN/styles.css"
  echo "== release: https://github.com/$FORK/releases/tag/$tag"
}

case "$cmd" in
  build)   do_build ;;
  check)   do_check ;;
  update)  do_update ;;
  release) do_release ;;
  -h|--help) sed -n '2,24p' "$0" ;;
  *) echo "unknown command: $cmd" >&2; exit 2 ;;
esac
