# Qzsh
This is my personal shell configuration, based largely on [Samastek's czsh](https://github.com/samastek/czsh), while not using [oh-my-zsh](https://www.github.com/ohmyzsh/ohmyzsh) as a plugin manager.

This config should work on all distros. However, I only tested {Debian, Ubuntu, Arch Linux} so far. Message me about any unsupported distro
# Installation
```bash
./setup.sh
```
Then run zsh:
```bash
zsh
```
and build the tab search module:
```bash
build-fzf-tab-module
```
Done! But to make this your default shell, run:
```bash
chsh -s $(which zsh)
```
or make bash always start zsh by adding it to bashrc
```bash
echo zsh >> ~/.bashrc
```
The command above is not recommended if you want to keep bash separately. History will in all cases remain separated between zsh and bash in their respective history files: `~/.zsh_history`, `~/.bash_history`

Here is how [powerlevel10k](https://github.com/romkatv/powerlevel10k)'s prompt (two lines) looks like. You can see the [fzf tab module](https://github.com/Aloxaf/fzf-tab), a brilliant fuzzy search program
![image](/docs/p10k-fzf-tab.png)
# Customizing qzsh
## Zsh addons
Any personal zsh configurations can be placed in the folder `~/.config/qzsh/zshrc/` and will override the default qzsh configs (see `~/.zshrc` after installation)
## Theme
You can edit p10k configuration in `~/.config/qzsh/qzshrc.zsh`. I have included comments to show how the prompt segments are constructed
## Oh-My-Zsh Plugins
While I still copy some zsh plugins from [oh-my-zsh](https://www.github.com/ohmyzsh/ohmyzsh), I do not use it as a framework.

If you prefer to use omz, this is the wrong repository. Go to my [brother's](https://github.com/samastek) very similar setup (see next section about czsh), which relies on omz
# Difference to czsh
- less plugins, missing: `zsh-codex`, `todo`...
- no nvim setup
- no `oh-my-zsh`
    - Install and source plugins directly
    - No need to update omz or live with its overhead
# Removing Qzsh
To disable qzsh on zsh, override `~/.zshrc`.

To get rid of this whole thing, here are all traces of qzsh (in case you love forensics):
```
~
├── .cache
│   ├── p10k*
│   └── zsh/*
├── .config
│   └── qzsh/*
├── .fonts/
│   ├── DejaVuSansMNerdFont-Regular.ttf
│   ├── HackNerdFont-Regular.ttf
│   └── RobotoMonoNerdFont-Regular.ttf
├── .fzf.bash
├── .fzf.zsh
├── .local
│   └── bin
│       └── lazydocker
├── .zcompdump*
└── .zshrc
```
