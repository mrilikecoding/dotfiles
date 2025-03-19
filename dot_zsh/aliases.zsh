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
alias czrun="czm && czg && czgs"



