export TERM="xterm-256color"
export CONFIGDIR="$HOME/.config/qzsh"

export ZSH_THEME="powerlevel10k/powerlevel10k"
POWERLEVEL9K_MODE='nerdfont-complete'
POWERLEVEL9K_OS_ICON_BACKGROUND="white"
POWERLEVEL9K_OS_ICON_FOREGROUND="blue"
POWERLEVEL9K_DIR_HOME_FOREGROUND="white"
POWERLEVEL9K_DIR_HOME_SUBFOLDER_FOREGROUND="white"
POWERLEVEL9K_DIR_DEFAULT_FOREGROUND="white"
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=( status command_execution_time background_jobs ram load)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true


if [[ -f $CONFIGDIR/zsh_codex/zsh_codex.plugin.zsh ]]; then
    source $CONFIGDIR/zsh_codex/zsh_codex.plugin.zsh
    bindkey '^X' create_completion
fi

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.config/czsh/bin
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

NPM_PACKAGES="${HOME}/.npm"
PATH="$NPM_PACKAGES/bin:$PATH"

[[ -s "$HOME/.config/czsh/marker/marker.sh" ]] && source "$HOME/.config/czsh/marker/marker.sh"
[[ -f "$CONFIGDIR/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$CONFIGDIR/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$CONFIGDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$CONFIGDIR/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$CONFIGDIR/zsh-completions/zsh-completions.plugin.zsh" ]] && source "$CONFIGDIR/zsh-completions/zsh-completions.plugin.zsh"
[[ -f "$CONFIGDIR/zsh-history-substring-search/zsh-history-substring-search.zsh" ]] && source "$CONFIGDIR/zsh-history-substring-search/zsh-history-substring-search.zsh"
[[ -f "$CONFIGDIR/fzf-tab/fzf-tab.plugin.zsh" ]] && source "$CONFIGDIR/fzf-tab/fzf-tab.plugin.zsh"
[[ -f "$CONFIGDIR/forgit/forgit.plugin.zsh" ]] && source "$CONFIGDIR/forgit/forgit.plugin.zsh"
[[ -f "$CONFIGDIR/z/z.plugin.zsh" ]] && source "$CONFIGDIR/z/z.plugin.zsh"


SAVEHIST=50000 #save upto 50,000 lines in history. oh-my-zsh default is 10,000
#setopt hist_ignore_all_dups     # dont record duplicated entries in history during a single session


# CUSTOM FUNCTIONS

# cheat sheets (github.com/chubin/cheat.sh), find out how to use commands
# example 'cheat tar'
# for language specific question supply 2 args first for language, second as the question
# eample: cheat python3 execute external program
cheat() {
    if [ "$2" ]; then
        curl "https://cheat.sh/$1/$2+$3+$4+$5+$6+$7+$8+$9+$10"
        else
        curl "https://cheat.sh/$1"
    fi
}

# Matrix screen saver! will run if you have installed "cmatrix"
# TMOUT=900
# TRAPALRM() { if command -v cmatrix &> /dev/null; then cmatrix -sb; fi }

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
    $BROWSER "https://www.google.com/search?q=${(j:+:)@}"
}

duckduckgo() {
    $BROWSER "https://duckduckgo.com/?q=${(j:+:)@}"
}

sp() {
    $BROWSER "https://www.startpage.com/do/search?query=${(j:+:)@}"
}

git config --global alias.amend '!git add -u && git commit --amend --no-edit && git push -f'
alias myip="wget -qO- https://wtfismyip.com/text" # quickly show external ip address
alias l="ls --hyperlink=auto -lAhrtF"             # show all except . .. , sort by recent, / at the end of folders, clickable
alias e="exit"
alias ip="ip --color=auto"
alias kp='ps -ef | fzf --multi | awk '\''{print $2}'\'' | xargs sudo kill -9'
alias git-update-all='find . -type d -name .git -execdir git pull --rebase --autostash \;'
alias c='clear'