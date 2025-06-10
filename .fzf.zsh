# Setup fzf
# ---------
if [[ ! "$PATH" == *$HOME/.config/qzsh/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}$HOME.config/qzsh/fzf/bin"
fi

source <(fzf --zsh)
