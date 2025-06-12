export TERM="xterm-256color"
export HISTFILE="$HOME/.zsh_history"
export CONFIGDIR="$HOME/.config/qzsh"

if [[ -f "$CONFIGDIR/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    source "$CONFIGDIR/themes/powerlevel10k/powerlevel10k.zsh-theme"
fi

export ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_OS_ICON_BACKGROUND="white"
POWERLEVEL9K_OS_ICON_FOREGROUND="blue"
POWERLEVEL9K_DIR_HOME_FOREGROUND="white"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="white"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"
typeset -g POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                  # exit status of last command
  command_execution_time  # how long last command took
  background_jobs         # number of background jobs
  ram                     # RAM usage
  load                    # system load
)
typeset -g POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  context         # user@hostname
  dir             # current directory
  vcs             # git info (branch, status)
)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true


if [[ -f $CONFIGDIR/plugins/zsh_codex/zsh_codex.plugin.zsh ]]; then
    source $CONFIGDIR/plugins/zsh_codex/zsh_codex.plugin.zsh
    bindkey '^X' create_completion
fi

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.config/qzsh/bin

NPM_PACKAGES="${HOME}/.npm"
PATH="$NPM_PACKAGES/bin:$PATH"

# zsh plugins

[[ -s "$CONFIGDIR/marker/marker.sh" ]] && source "$CONFIGDIR/marker/marker.sh"
[[ -f "$CONFIGDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$CONFIGDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$CONFIGDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$CONFIGDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$CONFIGDIR/plugins/zsh-completions/zsh-completions.plugin.zsh" ]] && source "$CONFIGDIR/plugins/zsh-completions/zsh-completions.plugin.zsh"
[[ -f "$CONFIGDIR/plugins/history-substring-search/zsh-history-substring-search.zsh" ]] && source "$CONFIGDIR/plugins/history-substring-search/zsh-history-substring-search.zsh"
[[ -f "$CONFIGDIR/plugins/fzf-tab/fzf-tab.plugin.zsh" ]] && source "$CONFIGDIR/plugins/fzf-tab/fzf-tab.plugin.zsh"
[[ -f "$CONFIGDIR/plugins/forgit/forgit.plugin.zsh" ]] && source "$CONFIGDIR/plugins/forgit/forgit.plugin.zsh"
[[ -f "$CONFIGDIR/plugins/z/z.plugin.zsh" ]] && source "$CONFIGDIR/plugins/z/z.plugin.zsh"

# useful omz libs

[[ -f "$CONFIGDIR/lib/key-bindings.zsh" ]] && source "$CONFIGDIR/lib/key-bindings.zsh"
[[ -f "$CONFIGDIR/lib/theme-and-appearance.zsh" ]] && source "$CONFIGDIR/lib/theme-and-appearance.zsh"

autoload -Uz compinit
export ZSH_CACHE_DIR="$HOME/.cache/zsh"
compinit -d "$HOME/.cache/zsh/.zcompdump"

setopt AUTO_CD
setopt HIST_VERIFY
setopt SHARE_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_IGNORE_SPACE
setopt HIST_SAVE_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt INC_APPEND_HISTORY
setopt EXTENDED_HISTORY


SAVEHIST=50000
HISTSIZE=50000

speedtest() {
    curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -
}

extract() {
    if [ -f $1 ] ; then
        case $1 in
            *.tar.bz2)   tar xjf $1     ;;
            *.tar.gz)    tar xzf $1     ;;
            *.bz2)       bunzip2 $1     ;;
            *.rar)       unrar e $1     ;;
            *.gz)        gunzip $1      ;;
            *.tar)       tar xf $1      ;;
            *.tbz2)      tar xjf $1     ;;
            *.tgz)       tar xzf $1     ;;
            *.zip)       unzip $1       ;;
            *.Z)         uncompress $1  ;;
            *.7z)        7z x $1        ;;
            *)     echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

sudo-command-line() {
    [[ -z $BUFFER ]] && zle up-history
    if [[ $BUFFER == sudo\ * ]]; then
        LBUFFER="${LBUFFER#sudo }"
    elif [[ $BUFFER == $EDITOR\ * ]]; then
        LBUFFER="${LBUFFER/#$EDITOR/sudoedit}"
    elif [[ $BUFFER == sudoedit\ * ]]; then
        LBUFFER="${LBUFFER/#sudoedit/$EDITOR}"
    else
        LBUFFER="sudo $LBUFFER"
    fi
}
zle -N sudo-command-line
bindkey "\e\e" sudo-command-line

google() {
    $BROWSER "https://www.google.com/search?&udm=14&gl=us&hl=en&pws=0&q=${(j:+:)@}&igu=1" # hopefully works, this does not let google track you
}

ddg() {
    $BROWSER "https://duckduckgo.com/?q=${(j:+:)@}"
}

wiki() {
    $BROWSER "https://en.wikipedia.org/wiki/Special:Search?search=${(j:+:)@}"
}
# Ensure key bindings are set up properly for history substring search
if [[ -f "$CONFIGDIR/plugins/history-substring-search/zsh-history-substring-search.zsh" ]]; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
fi