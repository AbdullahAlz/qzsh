#!/bin/bash

trap "exit" SIGINT

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
        git clone --depth 1 $FZF_REPO $FZF_INSTALLATION_PATH
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
    else
        git clone --depth 1 $LAZYDOCKER_REPO "$LAZYDOCKER_INSTALLATION_PATH"
    fi
    "$LAZYDOCKER_INSTALLATION_PATH"/scripts/install_update_linux.sh
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

install_omz_lib() { 
    local lib_url="https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/lib/$1"
    if wget -q --show-progress -O "$CONFIGDIR/lib/$1" "$lib_url"; then
        logInfo "Downloaded Oh-My-Zsh lib: $1"
    else
        logError "Failed to download Oh-My-Zsh lib: $1"
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


CONFIGDIR="$USER_HOME/.config/qzsh"
POWERLEVEL_10K_PATH="$CONFIGDIR/themes/powerlevel10k"
FZF_INSTALLATION_PATH="$CONFIGDIR/fzf"
LAZYDOCKER_INSTALLATION_PATH="$CONFIGDIR/lazydocker"
PLUGINS_DIR="$CONFIGDIR/plugins"

declare -A PLUGINS_MAP
export PLUGINS_MAP=(
    ["fzf-tab"]="https://github.com/Aloxaf/fzf-tab.git"
    ["zsh-syntax-highlighting"]="https://github.com/zsh-users/zsh-syntax-highlighting.git"
    ["zsh-autosuggestions"]="https://github.com/zsh-users/zsh-autosuggestions.git"
    ["zsh-completions"]="https://github.com/zsh-users/zsh-completions.git"
    ["history-substring-search"]="https://github.com/zsh-users/zsh-history-substring-search.git"
    ["forgit"]="https://github.com/wfxr/forgit.git"
)

###################### Script ######################

# backup existing .zshrc
if mv -n $USER_HOME/.zshrc $USER_HOME/.zshrc-backup-"$(date +"%Y-%m-%d")"; then
    logInfo "Backed up the current .zshrc to .zshrc-backup-date\n"
fi

mkdir -p "$CONFIGDIR"
mkdir -p "$CONFIGDIR/zshrc" # for future personal zshrc files
mkdir -p "$CONFIGDIR/themes"
mkdir -p "$CONFIGDIR/plugins"
mkdir -p "$CONFIGDIR/lib"
mkdir -p "$USER_HOME/.fonts"
mkdir -p "$USER_HOME/.cache/zsh" #later used by compinit

cp -f ./.zshrc $USER_HOME/
cp -f ./qzshrc.zsh $CONFIGDIR

missing_packages=()


# manually checking every command
# some packages have different names than their commands, I am not writing a pkg check for all distros
if ! command -v git &>/dev/null; then
    missing_packages+=("git")
fi
if ! command -v curl &>/dev/null; then
    missing_packages+=("curl")
fi
if ! command -v wget &>/dev/null; then
    missing_packages+=("wget")
fi
if ! command -v pip &>/dev/null; then
    missing_packages+=("python3-pip")
fi
if ! command -v fc &>/dev/null; then
    missing_packages+=("fontconfig")
fi
if ! command -v zsh &>/dev/null; then
    missing_packages+=("zsh")
fi
if ! command -v autoconf &>/dev/null; then
    missing_packages+=("autoconf")
fi
if ! command -v ncurses5-config &>/dev/null && ! command -v ncurses6-config &>/dev/null; then
    missing_packages+=("ncurses-dev")
fi

if [ ${#missing_packages[@]} -ne 0 ] && [ -z "$SUDO_USER" ]; then 
    logError "The following packages are missing: ${missing_packages[*]}"
    logWarning "Want to proceed with installation? sudo required (y/n)"
    read -r answer
    if [[ "$answer" != "y" && "$answer" != "Y" ]]; then
        logError "Installation aborted by user."
        exit 1
    fi


    perform_update

    for package in "${missing_packages[@]}"; do
        logProgress "Installing package: $package"
        installpkg "$package"
    done
fi


logProgress "Installing Oh-My-Zsh lib files"
install_omz_lib "key-bindings.zsh"
install_omz_lib "theme-and-appearance.zsh"

logProgress "Installing Powerlevel10k theme"

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

logInfo "Adding git aliases"
git config --global alias.amend '!git add -u && git commit --amend --no-edit && git push -f'

echo -e "\\033[1;32mDONE\n\\033[m"
logInfo "Installation complete, exit terminal and enter a new zsh session"
logWarning "Make sure to change zsh to default shell by running: chsh -s $(which zsh)"
logInfo "In a new zsh session manually run: build-fzf-tab-module. You might need to install ncurses-dev(el)"
