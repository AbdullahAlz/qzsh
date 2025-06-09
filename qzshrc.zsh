export TERM="xterm-256color"
export CONFIGDIR="$HOME/.config/qzsh"

# Source powerlevel10k theme
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
POWERLEVEL9K_RIGHT_PROMPT_ELEMENTS=( status command_execution_time background_jobs ram load)
POWERLEVEL9K_LEFT_PROMPT_ELEMENTS=(context dir vcs)
POWERLEVEL9K_PROMPT_ON_NEWLINE=true


if [[ -f $CONFIGDIR/plugins/zsh_codex/zsh_codex.plugin.zsh ]]; then
    source $CONFIGDIR/plugins/zsh_codex/zsh_codex.plugin.zsh
    bindkey '^X' create_completion
fi

export PATH=$PATH:~/.local/bin
export PATH=$PATH:~/.config/qzsh/bin
export PATH="$PATH:/opt/nvim-linux-x86_64/bin"

NPM_PACKAGES="${HOME}/.npm"
PATH="$NPM_PACKAGES/bin:$PATH"

[[ -s "$CONFIGDIR/marker/marker.sh" ]] && source "$CONFIGDIR/marker/marker.sh"
[[ -f "$CONFIGDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" ]] && source "$CONFIGDIR/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
[[ -f "$CONFIGDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]] && source "$CONFIGDIR/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
[[ -f "$CONFIGDIR/plugins/zsh-completions/zsh-completions.plugin.zsh" ]] && source "$CONFIGDIR/plugins/zsh-completions/zsh-completions.plugin.zsh"
[[ -f "$CONFIGDIR/plugins/history-substring-search/zsh-history-substring-search.zsh" ]] && source "$CONFIGDIR/plugins/history-substring-search/zsh-history-substring-search.zsh"
[[ -f "$CONFIGDIR/plugins/fzf-tab/fzf-tab.plugin.zsh" ]] && source "$CONFIGDIR/plugins/fzf-tab/fzf-tab.plugin.zsh"
[[ -f "$CONFIGDIR/plugins/forgit/forgit.plugin.zsh" ]] && source "$CONFIGDIR/plugins/forgit/forgit.plugin.zsh"
[[ -f "$CONFIGDIR/plugins/z/z.plugin.zsh" ]] && source "$CONFIGDIR/plugins/z/z.plugin.zsh"

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


git config --global alias.amend '!git add -u && git commit --amend --no-edit && git push -f'
alias myip="wget -qO- https://wtfismyip.com/text" # quickly show external ip address
alias l="ls -lah"
alias e="exit"
alias ip="ip --color=auto"
alias kp='ps -ef | fzf --multi | awk '\''{print $2}'\'' | xargs sudo kill -9'
alias git-update-all='find . -type d -name .git -execdir git pull --rebase --autostash \;'
alias c='clear'

# Debug function to check plugin status
qzsh-debug() {
    echo "=== QZSH Debug Information ==="
    echo "Config directory: $CONFIGDIR"
    echo "Powerlevel10k theme: $([ -f "$CONFIGDIR/themes/powerlevel10k/powerlevel10k.zsh-theme" ] && echo "✅ Found" || echo "❌ Missing")"
    echo "Plugins status:"
    for plugin in zsh-autosuggestions zsh-syntax-highlighting zsh-completions history-substring-search fzf-tab forgit z; do
        if [[ -f "$CONFIGDIR/plugins/$plugin/"*.zsh ]] || [[ -f "$CONFIGDIR/plugins/$plugin/"*.plugin.zsh ]]; then
            echo "  $plugin: ✅ Loaded"
        else
            echo "  $plugin: ❌ Missing"
        fi
    done
    echo "FZF: $([ -f "$HOME/.config/qzsh/fzf/bin/fzf" ] && echo "✅ Installed" || echo "❌ Missing")"
    echo "Key bindings:"
    echo "  Ctrl+X: $(bindkey | grep -q '\^X' && echo "✅ zsh_codex" || echo "❌ Not bound")"
    echo "  Ctrl+R: $(bindkey | grep -q '\^R' && echo "✅ FZF history" || echo "❌ Not bound")"
    echo "=========================="
}

# Ensure key bindings are set up properly for history substring search
if [[ -f "$CONFIGDIR/plugins/history-substring-search/zsh-history-substring-search.zsh" ]]; then
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
fi