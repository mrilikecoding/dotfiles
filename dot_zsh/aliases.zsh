# shell config
alias zshconfig="$EDITOR ~/.zshrc"
alias zprofile="$EDITOR ~/.zprofile"
alias zshenv="$EDITOR ~/.zshenv"

# alias aliases :)
alias list_aliases="cat ~/.zsh/aliases.zsh"
alias aliasconfig="$EDITOR ~/.zsh/aliases.zsh"

# tool config
alias awsconfig="$EDITOR ~/.aws/config"
alias sshconfig="$EDITOR ~/.ssh/config"
alias tmuxconfig="$EDITOR ~/.tmux.conf"
alias nvimconfig="$EDITOR ~/.config/nvim/init.lua"
alias starshipconfig="$EDITOR ~./config/starship.toml"
alias chezmoiconfig="$EDITOR ~/.zsh/chezmoi.zsh"
alias czconfig="$EDITOR ~/.zsh/chezmoi.zsh"
alias secretsconfig="$EDITOR ~/.zsh/secrets.zsh"

# command aliases
alias la="ll -a"
alias gs="git status"
alias docker-compose="docker compose"
alias dc="docker compose"
alias ports="lsof -i -P | grep LISTEN"
alias edit="$EDITOR ."
alias reload="source ~/.zshrc" # or ~/.bashrc
alias c="clear"
alias h="history"
alias bdf="brew bundle dump --force" # update Brewfile
alias bb="brew bundle"

# chezmoi shortcuts
alias cz="chezmoi"
alias cza="chezmoi add"
alias czapply="chezmoi apply"
alias czs="chezmoi status"
alias czd="chezmoi diff"
alias cze="chezmoi edit"
alias czu="chezmoi update"
alias czm="chezmoi_manage"
alias czpath="chezmoi source-path"
alias czg="chezmoi_git_status"
alias czgs="chezmoi_git_sync"
alias czrun="chezmoi_run"

# Tmux pane management aliases
alias tsplit="tmux split-window -h"     # Split vertically (side by side)
alias tvsplit="tmux split-window -v"    # Split horizontally (one above the other)
alias tkill="tmux kill-pane"            # Kill the current pane
alias tnew="tmux new-window"     # Create a new window
alias tleft="tmux swap-pane -D"      # Move pane left
alias tright="tmux swap-pane -U"     # Move pane right
alias tup="tmux swap-pane -U"        # Move pane up
alias tdown="tmux swap-pane -D"      # Move pane down

