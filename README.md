# Qzsh

This is my personal Shell configuration, based largely on [Samastek's work](https://github.com/samastek/czsh), while not using [oh-my-zsh](https://www.github.com/ohmyzsh/ohmyzsh) as a plugin manager.

# Installation
```bash
./setup.sh
```
After installation, you can test this configuration by running:
```bash
zsh
```
The script will tell you in the end that you need to run

```bash
build-fzf-tab-module
```

That concludes installation.

If you then decide to use this configuration as your default shell, run:
```bash
chsh -s $(which zsh)
```



Here is how it looks like. The image shows  [powerlevel10k](https://github.com/romkatv/powerlevel10k)'s prompt (two lines) and the [fzf tab module](https://github.com/Aloxaf/fzf-tab) I use to search through possible completions of any command

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

- less plugins, missing: `zsh-codex`, `todo`. I do not use those.
- no nvim setup
- no `oh-my-zsh`
    - Install and source plugins directly
    - No need to update omz or live with its overhead

# Removing Qzsh
To disable qzsh on zsh, override `~/.zshrc`.

Here are all files created or modified by this script:

```
$HOME
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
├── .zcompdump* (see date of creation)
└── .zshrc
```