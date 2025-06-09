# Setup fzf
# ---------
if [[ ! "$PATH" == */home/user/.config/qzsh/fzf/bin* ]]; then
  PATH="${PATH:+${PATH}:}/home/user/.config/qzsh/fzf/bin"
fi

source <(fzf --zsh)
