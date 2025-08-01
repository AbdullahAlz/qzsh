OLDTERM=$TERM
export TERM="xterm-256color"
export HISTFILE="$HOME/.zsh_history"
export CONFIGDIR="$HOME/.config/qzsh"
export ZSH_THEME="powerlevel10k/powerlevel10k"
export PATH=$PATH:~/.local/bin:~/.config/qzsh/bin
export ZSH_CACHE_DIR="$HOME/.cache/zsh"

NPM_PACKAGES="${HOME}/.npm"
PATH="$NPM_PACKAGES/bin:$PATH"

SAVEHIST=50000
HISTSIZE=50000

# Powerlevel10k Settings
if [[ -f "$CONFIGDIR/themes/powerlevel10k/powerlevel10k.zsh-theme" ]]; then
    source "$CONFIGDIR/themes/powerlevel10k/powerlevel10k.zsh-theme"
fi

POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_PROMPT_ON_NEWLINE=true
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"
POWERLEVEL9K_DIR_HOME_FOREGROUND="white"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="white"
POWERLEVEL9K_RAM_BACKGROUND="green"
POWERLEVEL9K_MULTILINE_FIRST_PROMPT_PREFIX=""
POWERLEVEL9K_MULTILINE_LAST_PROMPT_PREFIX=""
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=(
  status                    # exit status of last command
  command_execution_time    # how long last command took
  background_jobs           # number of background jobs
  load                      # system load
)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(
  context                   # user@hostname
  dir                       # current directory
  vcs                       # git info (branch, status)
)

HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_FOUND='bg=magenta,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_HIGHLIGHT_NOT_FOUND='bg=red,fg=white,bold'
HISTORY_SUBSTRING_SEARCH_GLOBBING_FLAGS='i'

if [[ -f $CONFIGDIR/plugins/zsh_codex/zsh_codex.plugin.zsh ]]; then
    source $CONFIGDIR/plugins/zsh_codex/zsh_codex.plugin.zsh
    [[ -o zle ]] && bindkey '^X' create_completion
fi

[[ -f "$CONFIGDIR/lib/key-bindings.zsh" ]] && source "$CONFIGDIR/lib/key-bindings.zsh"
[[ -f "$CONFIGDIR/lib/theme-and-appearance.zsh" ]] && source "$CONFIGDIR/lib/theme-and-appearance.zsh"
# zsh plugins
[[ -f "$CONFIGDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$CONFIGDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$CONFIGDIR/plugins/zsh-completions/zsh-completions.plugin.zsh" ]] && source "$CONFIGDIR/plugins/zsh-completions/zsh-completions.plugin.zsh"
[[ -f "$CONFIGDIR/plugins/history-substring-search/zsh-history-substring-search.zsh" ]] && source "$CONFIGDIR/plugins/history-substring-search/zsh-history-substring-search.zsh"
[[ -f "$CONFIGDIR/plugins/fzf-tab/fzf-tab.plugin.zsh" ]] && source "$CONFIGDIR/plugins/fzf-tab/fzf-tab.plugin.zsh"
[[ -f "$CONFIGDIR/plugins/forgit/forgit.plugin.zsh" ]] && source "$CONFIGDIR/plugins/forgit/forgit.plugin.zsh"
[[ -f "$CONFIGDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$CONFIGDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

autoload -Uz compinit
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

google() {
    open "https://www.google.com/search?&udm=14&gl=us&hl=en&pws=0&q=${(j:+:)@}&igu=1" # hopefully works, this does not let google track you
}

ddg() {
    open "https://duckduckgo.com/?q=${(j:+:)@}"
}

wiki() {
    open "https://en.wikipedia.org/wiki/Special:Search?search=${(j:+:)@}"
}

showallcolors() {
    for i in {0..255}; do
    printf "\e[48;5;${i}m %3d \e[0m" $i
    if (( ($i + 1) % 16 == 0 )); then
        echo
    fi
done
}

set_classic_mode() {
    POWERLEVEL9K_MODE='classic'
    POWERLEVEL9K_RAM_ICON=""
    POWERLEVEL9K_EXECUTION_TIME_ICON=""
    POWERLEVEL9K_FOLDER_ICON=""
    POWERLEVEL9K_LOAD_ICON=""
    POWERLEVEL9K_LEFT_SEGMENT_END_SEPARATOR=""
    POWERLEVEL9K_LEFT_SEGMENT_SEPARATOR=""
    POWERLEVEL9K_LEFT_SUBSEGMENT_SEPARATOR=""
    POWERLEVEL9K_RIGHT_SEGMENT_SEPARATOR=""
    POWERLEVEL9K_RIGHT_SUBSEGMENT_SEPARATOR=""
    POWERLEVEL9K_VCS_UNSTAGED_ICON="!"
    POWERLEVEL9K_VCS_UNTRACKED_ICON="?"
    POWERLEVEL9K_VCS_STASH_ICON="S"
    POWERLEVEL9K_VCS_STAGED_ICON="+"
    POWERLEVEL9K_VCS_INCOMING_CHANGES_ICON="↓"
    POWERLEVEL9K_VCS_OUTGOING_CHANGES_ICON="↑"
    POWERLEVEL9K_VCS_REMOTE_BRANCH_ICON="→"
    POWERLEVEL9K_VCS_BRANCH_ICON=""
}

#If history substring does not work, find out what arrows are (usually ^[[A) and hardcode them below
if [[ -n "${terminfo[kcuu1]}" && -n "${terminfo[kcud1]}" && -o zle ]]; then
    bindkey "${terminfo[kcuu1]}" history-substring-search-up
    bindkey "${terminfo[kcud1]}" history-substring-search-down
else
    bindkey "^[[A" history-substring-search-up
    bindkey "^[[B" history-substring-search-down
fi

if [[ "$(tty)" == "/dev/tty"* || "$OLDTERM" == "linux" || "$OLDTERM" == "xterm" || "$OLDTERM" == "dumb" || "$TERMINAL_EMULATOR" == "JetBrains-JediTerm" ]]; then
    set_classic_mode
fi

zle -N sudo-command-line
bindkey "\e\e" sudo-command-line
bindkey "^[[3;3~" kill-region

alias e="exit"
alias ip="ip --color=auto"
alias kp='ps -ef | fzf --multi | awk '\''{print $2}'\'' | xargs sudo kill -9'
alias git-update-all='find . -type d -name .git -execdir git pull --rebase --autostash \;'

alias c='clear'
alias l="ls -lah"
alias myip="wget -qO- https://ipv4.wtfismyip.com/text"
alias myip6="wget -qO- https://ipv6.wtfismyip.com/text"
alias myipl="hostname -I | awk '{print \$1}'"

alias ...="../.."
alias ....="../../.."
alias .....="../../../.."
alias ......="../../../../.."
alias 1="cd -"
alias _="sudo"
alias grep="grep --color=auto"