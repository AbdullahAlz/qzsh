source "$HOME/.config/qzsh/qzshrc.zsh"
ZSH_CONFIGS_DIR="$HOME/.config/qzsh/zshrc"
if [ "$(ls -A $ZSH_CONFIGS_DIR)" ]; then
    for file in "$ZSH_CONFIGS_DIR"/* "$ZSH_CONFIGS_DIR"/.*; do
        if [ -f "$file" ]; then
            source "$file"
        fi
    done
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[ -f "$HOME/.config/qzsh/fzf/shell/key-bindings.zsh" ] && source "$HOME/.config/qzsh/fzf/shell/key-bindings.zsh"
[ -f "$HOME/.config/qzsh/fzf/shell/completion.zsh" ] && source "$HOME/.config/qzsh/fzf/shell/completion.zsh"
export FZF_DEFAULT_OPS="--extended"

[ -f "/home/user/.ghcup/env" ] && . "/home/user/.ghcup/env"