source "$HOME/.config/qzsh/qzshrc.zsh"

# Any zshrc configurations under the folder ~/.config/qzsh/zshrc/ will override the default qzsh configs.
# Place all of your personal configurations over there
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

alias e="exit"
alias ip="ip --color=auto"
alias kp='ps -ef | fzf --multi | awk '\''{print $2}'\'' | xargs sudo kill -9'
alias git-update-all='find . -type d -name .git -execdir git pull --rebase --autostash \;'

alias c='clear'
alias l="ls -lah"
alias myip="wget -qO- https://ipv4.wtfismyip.com/text"
alias myip6="wget -qO- https://ipv6.wtfismyip.com/text"