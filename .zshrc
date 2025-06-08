source "$HOME/.config/qzsh/qzshrc.zsh"

# Additional zsh configs to override qzsh with
ZSH_CONFIGS_DIR="$HOME/.config/qzsh/zshrc"

if [ "$(ls -A $ZSH_CONFIGS_DIR)" ]; then
    for file in "$ZSH_CONFIGS_DIR"/* "$ZSH_CONFIGS_DIR"/.*; do
        # Exclude '.' and '..' from being sourced
        if [ -f "$file" ]; then
            source "$file"
        fi
    done
fi


[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
export FZF_DEFAULT_OPS="--extended"

[ -f "/home/user/.ghcup/env" ] && . "/home/user/.ghcup/env" # ghcup-env