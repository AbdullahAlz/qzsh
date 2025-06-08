#!/bin/bash
###################### Global Variables ######################

if [ -n "$SUDO_USER" ]; then
    USER_HOME=$(eval echo "~$SUDO_USER")
else
    USER_HOME="$HOME"
fi

POWERLEVEL10K_REPO="https://github.com/romkatv/powerlevel10k.git"
FZF_REPO="https://github.com/junegunn/fzf.git"
LAZYDOCKER_REPO="https://github.com/jesseduffield/lazydocker.git"

CONFIGDIR="$USER_HOME/.config/qzsh"
POWERLEVEL_10K_PATH=$CONFIGDIR/powerlevel10k
FZF_INSTALLATION_PATH=$CONFIGDIR/fzf  
LAZYDOCKER_INSTALLATION_PATH=$CONFIGDIR/lazydocker

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

logInfo "Installed following packages: ${installedPackages[*]}"

installpkg "zsh"
installpkg "git"
installpkg "curl"
installpkg "wget"
installpkg "python3-pip"
installpkg "fontconfig"

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

installedPackages=()
installpkg(){
        if sudo apt install -y "$1" || sudo pacman -S "$1" || sudo dnf install -y "$1" || sudo yum install -y "$1" || sudo brew install "$1" || pkg install "$1"; then
            installedPackages+=("$1")
        else
            logError "Failed to install package '$1'."
        fi
}

perform_update() {
    if sudo apt update || sudo pacman -Sy || sudo dnf check-update || sudo yum check-update || brew update || pkg update; then
    else
        logError "System update failed\n"
    fi
}

logWarning "Place your personal zshrc config files under '$HOME/.config/czsh/zshrc/'\n"

mkdir -p "$CONFIGDIR"
mkdir -p "$CONFIGDIR/zshrc"
mkdir -p "$USER_HOME/.fonts"
mkdir -p "$USER_HOME/.cache/zsh" # for .zcompdump files

cp -f ./.zshrc $HOME/
cp -f ./3f4zshrc.zsh $CONFIGDIR

if [ -f $HOME/.zcompdump ]; then
    mv $HOME/.zcompdump* $HOME/.cache/zsh/
fi

# Install Powerlevel10k

if [ -d "$POWERLEVEL_10K_PATH" ]; then
    git -C "$POWERLEVEL_10K_PATH" pull
else
    git clone --depth=1 $POWERLEVEL10K_REPO "$POWERLEVEL_10K_PATH"
fi


logProgress "Installing Nerd Fonts"

if [ ! -f $HOME/.fonts/HackNerdFont-Regular.ttf ]; then
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/Hack/Regular/HackNerdFont-Regular.ttf -P $HOME/.fonts/
fi

if [ ! -f $HOME/.fonts/RobotoMonoNerdFont-Regular.ttf ]; then
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/RobotoMono/Regular/RobotoMonoNerdFont-Regular.ttf -P $HOME/.fonts/
fi

if [ ! -f $HOME/.fonts/DejaVuSansMNerdFont-Regular.ttf ]; then
    wget -q --show-progress -N https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DejaVuSansMono/Regular/DejaVuSansMNerdFont-Regular.ttf -P $HOME/.fonts/
fi

fc-cache -fv $HOME/.fonts

logProgress "Installing fuzzy finder"


if [ -d $FZF_INSTALLATION_PATH ]; then
    git -C $FZF_INSTALLATION_PATH pull
    $FZF_INSTALLATION_PATH/install --all --key-bindings --completion --no-update-rc
else
    git clone --branch 0.60.3 --depth 1 $FZF_REPO $FZF_INSTALLATION_PATH
    "$FZF_INSTALLATION_PATH"/install --all --key-bindings --completion --no-update-rc
fi

logProgress "Installing lazydocker"

if [ -d "$LAZYDOCKER_INSTALLATION_PATH" ]; then
    git -C $LAZYDOCKER_INSTALLATION_PATH pull
    "$LAZYDOCKER_INSTALLATION_PATH"/scripts/install_update_linux.sh
else
    git clone --depth 1 $LAZYDOCKER_REPO "$LAZYDOCKER_INSTALLATION_PATH"
    "$LAZYDOCKER_INSTALLATION_PATH"/scripts/install_update_linux.sh
fi
sleep 3

logProgress "Installing zsh plugins"

for PLUGIN_NAME in "${!PLUGINS_MAP[@]}"; do
    PLUGIN_PATH="$CONFIGDIR/$PLUGIN_NAME"
    if [ -d "$PLUGIN_PATH" ]; then
        logInfo "$PLUGIN_NAME plugin already exists, updating..."
        git -C "$PLUGIN_PATH" pull
    else
        PLUGIN_REPO_LINK="${PLUGINS_MAP[$PLUGIN_NAME]}"
        git clone --depth=1 "$PLUGIN_REPO_LINK" "$PLUGIN_PATH"
        logInfo "$PLUGIN_NAME plugin installed"
    fi
done
