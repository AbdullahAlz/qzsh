source "$HOME/.config/qzsh/qzshrc.zsh"
# This enables any user 
ZSH_CONFIGS_DIR="$HOME/.config/qzsh/zshrc"
if [ "$(ls -A $ZSH_CONFIGS_DIR)" ]; then
    for file in "$ZSH_CONFIGS_DIR"/* "$ZSH_CONFIGS_DIR"/.*; do
        if [ -f "$file" ]; then
            source "$file"
        fi
    done
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"

[ -f "/home/user/.ghcup/env" ] && . "/home/user/.ghcup/env"

alias c='clear'
alias l="ls -lah"
alias myip="wget -qO- https://ipv4.wtfismyip.com/text"
alias myip6="wget -qO- https://ipv6.wtfismyip.com/text"