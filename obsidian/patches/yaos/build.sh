#!/bin/bash
#
# Build the patched YAOS plugin (and optionally deploy the patched server).
#
#   build.sh [build] [--deploy-server]   clone upstream at UPSTREAM_TAG, apply
#                                        patches, build, copy into the profile
#   build.sh check                       compare UPSTREAM_TAG with GitHub's latest
#                                        release; exit 0 = current, 10 = newer
#                                        upstream exists, 1 = could not check
#   build.sh update [--deploy-server]    bump UPSTREAM_TAG to latest, then build
#
# Patches live next to this script. If one stops applying after an upstream
# bump, fix the patch and re-run. The manifest keeps upstream's version so
# Obsidian's updater stays quiet; provenance is in the .patched marker.
#
# After --deploy-server, restart the YAOS plugin on EVERY device: a Worker
# redeploy leaves existing sync sockets half-dead (learned 2026-09-14).

set -euo pipefail

here="$(cd "$(dirname "$0")" && pwd -P)"
DOTFILES="$(cd "$here/../../.." && pwd -P)"
PROFILE_PLUGIN="$DOTFILES/obsidian/default/plugins/yaos"
REPO="https://github.com/kavinsood/yaos.git"
API_LATEST="https://api.github.com/repos/kavinsood/yaos/releases/latest"
WORK="${YAOS_BUILD_DIR:-$HOME/.cache/obsidian-profile/yaos-src}"

cmd="${1:-build}"; shift || true
deploy=0
for a in "$@"; do case "$a" in --deploy-server) deploy=1 ;; *) echo "unknown option: $a" >&2; exit 2 ;; esac; done

pinned() { tr -d '[:space:]' < "$here/UPSTREAM_TAG"; }

latest_tag() {
  curl -fsS --max-time 8 -A 'obsidian-profile' "$API_LATEST" \
    | python3 -c 'import json,sys; print(json.load(sys.stdin)["tag_name"].lstrip("v"))'
}

do_check() {
  local cur lat
  cur="$(pinned)"
  lat="$(latest_tag)" || { echo "yaos: could not reach GitHub to check for releases" >&2; return 1; }
  if [ "$cur" = "$lat" ]; then
    echo "yaos: pinned $cur is the latest release"
    return 0
  fi
  echo "yaos: upstream $lat available (pinned $cur). Run: $here/build.sh update"
  return 10
}

do_build() {
  local tag; tag="$(pinned)"
  echo "== yaos $tag: fetching source"
  rm -rf "$WORK"; mkdir -p "$(dirname "$WORK")"
  git -c advice.detachedHead=false clone -q --depth 1 --branch "$tag" "$REPO" "$WORK"

  echo "== applying patches"
  ( cd "$WORK" && git apply --check "$here/plugin.patch" "$here/server.patch" && git apply "$here/plugin.patch" "$here/server.patch" )

  echo "== building plugin"
  ( cd "$WORK" && npm ci --silent && npm run build --silent )

  echo "== installing into profile: $PROFILE_PLUGIN"
  mkdir -p "$PROFILE_PLUGIN"
  cp "$WORK/main.js" "$WORK/manifest.json" "$WORK/styles.css" "$PROFILE_PLUGIN/"
  {
    echo "upstream=$tag"
    echo "plugin_patch_sha256=$(shasum -a 256 "$here/plugin.patch" | cut -c1-16)"
    echo "server_patch_sha256=$(shasum -a 256 "$here/server.patch" | cut -c1-16)"
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

case "$cmd" in
  build)  do_build ;;
  check)  do_check ;;
  update)
    lat="$(latest_tag)" || { echo "could not determine latest release" >&2; exit 1; }
    echo "$lat" > "$here/UPSTREAM_TAG"; echo "pinned -> $lat"
    do_build ;;
  -h|--help) sed -n '2,18p' "$0" ;;
  *) echo "unknown command: $cmd" >&2; exit 2 ;;
esac
