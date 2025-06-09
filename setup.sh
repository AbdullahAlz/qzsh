#!/bin/bash

###################### Functions ######################

echoIULRed() {
    echo -e "\\033[3;4;31m$*\\033[m"
}

logWarning() {
    echo -e "\\033[33m$*\\033[m"
}

logInfo() {
    echo -e "\\033[32m$*\\033[m"
}

logError() {
    echo -e "\\033[31m$*\\033[m"
}

logProgress() {
    echo -e "\\033[36m$*\\033[m"
}

installpkg(){
        if sudo apt install -y "$1" || sudo pacman -S "$1" || sudo dnf install -y "$1" || sudo yum install -y "$1" || sudo brew install "$1" || pkg install "$1"; then
            installedPackages+=("$1")
            logInfo "Installed '$1'"
        else
            logError "Failed to install package '$1'."
        fi
}

perform_update() {
    if sudo apt update || sudo pacman -Sy || sudo dnf check-update || sudo yum check-update || brew update || pkg update; then
        logProgress "System update successful.\n"
    else
        logError "System update failed\n"
    fi
}

install_fzf() {
    if [ -d $FZF_INSTALLATION_PATH ]; then
        git -C $FZF_INSTALLATION_PATH pull
        $FZF_INSTALLATION_PATH/install --all --key-bindings --completion --no-update-rc
    else
        git clone --branch 0.60.3 --depth 1 $FZF_REPO $FZF_INSTALLATION_PATH
        "$FZF_INSTALLATION_PATH"/install --all --key-bindings --completion --no-update-rc
    fi

}

install_powerlevel10k() {
    if [ -d "$POWERLEVEL_10K_PATH" ]; then
        git -C "$POWERLEVEL_10K_PATH" pull
    else
        git clone --depth=1 $POWERLEVEL10K_REPO "$POWERLEVEL_10K_PATH"
    fi
}

install_lazydocker() {
    if [ -d "$LAZYDOCKER_INSTALLATION_PATH" ]; then
        git -C $LAZYDOCKER_INSTALLATION_PATH pull
        "$LAZYDOCKER_INSTALLATION_PATH"/scripts/install_update_linux.sh
    else
        git clone --depth 1 $LAZYDOCKER_REPO "$LAZYDOCKER_INSTALLATION_PATH"
        "$LAZYDOCKER_INSTALLATION_PATH"/scripts/install_update_linux.sh
    fi
    sleep 3

}

install_custom_fonts() {
    if [ ! -f $USER_HOME/.fonts/HackNerdFont-Regular.ttf ]; then
        wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf -P $HOME/.fonts/
    fi

    if [ ! -f $USER_HOME/.fonts/RobotoMonoNerdFont-Regular.ttf ]; then
        wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/RobotoMonoNerdFont-Regular.ttf -P $HOME/.fonts/
    fi

    if [ ! -f $USER_HOME/.fonts/DejaVuSansMNerdFont-Regular.ttf ]; then
        wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFont-Regular.ttf -P $HOME/.fonts/
    fi
}

###################### Global Variables ######################

if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
else
    USER_HOME="$HOME"
fi
logWarning "Place your personal zshrc config files under '$USER_HOME/.config/czsh/zshrc/'\n"

POWERLEVEL10K_REPO="https://github.com/romkatv/powerlevel10k.git"
FZF_REPO="https://github.com/junegunn/fzf.git"
LAZYDOCKER_REPO="https://github.com/jesseduffield/lazydocker.git"

noninteractive_flag=true
cp_hist_flag=false
zsh_codex_flag=false

for arg in "$@"; do
    case $arg in
    --cp-hist | -c)
        cp_hist_flag=true
        ;;
    --interactive | -n)
        noninteractive_flag=false
        ;;
    --codex | -x)
        zsh_codex_flag=true
        ;;
    *)
        ;;
    esac
done

CONFIGDIR="$USER_HOME/.config/qzsh"
POWERLEVEL_10K_PATH=$CONFIGDIR/themes/powerlevel10k
FZF_INSTALLATION_PATH=$CONFIGDIR/fzf  
LAZYDOCKER_INSTALLATION_PATH=$CONFIGDIR/lazydocker
PLUGINS_DIR=$CONFIGDIR/plugins

declare -A PLUGINS_MAP
export PLUGINS_MAP=(
    ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab.git"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
    ["zsh-completions"]="https://github.com/zsh-users/zsh-completions.git"
    ["history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search.git"
    ["z"]="https://github.com/agkozak/zsh-z.git"
    ["forgit"]="https://github.com/wfxr/forgit.git"
)

###################### Script ######################

installedPackages=()
perform_update
installpkg "zsh"
installpkg "git"
installpkg "curl"
installpkg "wget"
installpkg "python3-pip"
installpkg "fontconfig"
perform_update
installpkg "autoconf"
installpkg "ncurses-dev"

mkdir -p "$CONFIGDIR"
mkdir -p "$CONFIGDIR/zshrc"
mkdir -p "$CONFIGDIR/themes"
mkdir -p "$CONFIGDIR/plugins"
mkdir -p "$USER_HOME/.fonts"
mkdir -p "$USER_HOME/.cache/zsh" # for .zcompdump files

cp -f ./.zshrc $USER_HOME/
cp -f ./qzshrc.zsh $CONFIGDIR
cp -f ./fzf.zsh $USER_HOME

if [ -f $USER_HOME/.zcompdump ]; then
    mv $USER_HOME/.zcompdump* $USER_HOME/.cache/zsh/
fi

install_powerlevel10k

logProgress "Installing Nerd Fonts"

install_custom_fonts
fc-cache -fv $USER_HOME/.fonts

logProgress "Installing fuzzy finder"

install_fzf

logProgress "Installing lazydocker"

install_lazydocker

logProgress "Installing zsh plugins"

for PLUGIN_NAME in "${!PLUGINS_MAP[@]}"; do
    PLUGIN_PATH="$PLUGINS_DIR/$PLUGIN_NAME"
    if [ -d "$PLUGIN_PATH" ]; then
        logInfo "$PLUGIN_NAME plugin already exists, updating..."
        git -C "$PLUGIN_PATH" pull
    else
        PLUGIN_REPO_LINK="${PLUGINS_MAP[$PLUGIN_NAME]}"
        git clone --depth=1 "$PLUGIN_REPO_LINK" "$PLUGIN_PATH"
        logInfo "$PLUGIN_NAME plugin installed"
    fi
done

if [ "$zsh_codex_flag" = true ]; then
    logProgress "Configuring zsh_codex"
    if [ ! -d "$PLUGINS_DIR/zsh_codex" ]; then
        git clone --depth=1 "https://github.com/samastek/zsh_codex.git" "$PLUGINS_DIR/zsh_codex"
    fi
    cp zsh_codex.ini $USER_HOME/.config/ 2>/dev/null || logWarning "zsh_codex.ini not found"
    pip3 install openai --break-system-packages 2>/dev/null || logWarning "Failed to install openai"
    pip3 install groq --break-system-packages 2>/dev/null || logWarning "Failed to install groq"
fi

if [ "$zsh_codex_flag" = true ]; then
    logInfo "zsh_codex is enabled - use Ctrl+X for AI completions"
fi

if [ "$noninteractive_flag" = true ]; then
    logInfo "Installation complete, exit terminal and enter a new zsh session\n"
    logWarning "Make sure to change zsh to default shell by running: chsh -s $(which zsh)"
    logInfo "In a new zsh session manually run: build-fzf-tab-module"
else
    logWarning "\nSudo access is needed to change default shell\n"

    if chsh -s "$(which zsh)"; then
        logInfo "Installation complete, exit terminal and enter a new zsh session"
        logWarning "In a new zsh session manually run: build-fzf-tab-module"
    else
        logError "Something is wrong, the password you entered might be wrong\n"

    fi
fi

logInfo "Installed following packages: ${installedPackages[*]}"