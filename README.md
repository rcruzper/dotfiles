# Dotfiles

This is my set of configuration files to get ready in any new machine. If you want to know more about dotfiles, see [dotfiles.github.io](https://dotfiles.github.io/).

## Requirements
- [iTerm 2.9](https://iterm2.com/downloads/beta/iTerm2-2_9_20160313.zip)
- User password is required to fix brew permissions and add zsh as default shell

## Installation

```terminal
git clone --recursive git@github.com:rcruzper/dotfiles.git ~/.dotfiles
~/.dotfiles/script/bootstrap
```

If you want to update the configuration, you just need to execute `~/.dotfiles/script/bootstrap` again.

## Utilities installed
- zsh
- zgen
- git
- node
- z
- timedog
- openssl
- maven
- gradle
- tree
- python
- httpie
- fzf
- atom
- dockertoolbox
- libreoffice
- sequel-pro
- sts
- font-fira-mono

## TODO
- [ ] Demo gif
- [x] ~~How to install~~
- [x] ~~Fix permissions for homebrew before installation~~
- [x] ~~Update brew if it is already installed~~
- [ ] Add selectable list for brew packages
- [ ] Commands more used
- [ ] Brew link unlinked kegs
- [x] ~~Add /usr/local/bin/zsh as default shell (chsh)~~
- [x] ~~Input option to change gitconfig data~~
- [x] ~~Split macos-linux options~~
- [x] ~~Improve logs~~
- [x] ~~Set requeriments~~
- [ ] Write description about the apps and scripts executed
- [ ] Uninstall
- [x] ~~Docker execution at startup optional~~
- [x] ~~Update script~~
- [ ] Update zgen at bootstrap
- [ ] Avoid password if brew permissions are correct

## Bugs
If you have any problem installing dotfiles, please [open an issue](https://github.com/rcruzper/dotfiles/issues).
