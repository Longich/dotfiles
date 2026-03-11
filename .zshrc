# lsの色設定
export LSCOLORS=gxfxcxdxbxegedabagacad

# alias
alias ls='ls --color=auto'
alias la='ls -a'

## Docker login
alias de='(){docker exec -it $1 /bin/bash}'
## bundle exec
alias be='bundle exec'
## gitの派生元を表示
alias parent-branch='git show-branch | grep '\''*'\'' | grep -v '\"'$(git rev-parse --abbrev-ref HEAD)'\"' | head -1 | awk -F'\''[]~^[]'\'' '\''{print $2}'\'

export EDITOR='cursor --wait'
# local bin path (ex. claude, mise)
export PATH="$HOME/.local/bin:$PATH"
# mise
eval "$(mise activate zsh)"

[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local


