# Qzsh

This is my personal Shell configuration, based entirely on [Samastek's work](https://github.com/samastek/czsh).

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

# Removing Qzsh
Files installed by this script are:
- `~/.zshrc`
-  `~/.config/qzsh/*`
-  `~/.local/bin/lazydocker`




