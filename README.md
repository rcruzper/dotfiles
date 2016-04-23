# Dotfiles

![](https://raw.githubusercontent.com/rcruzper/dotfiles/master/dotfiles.png)

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

### iTerm2 configuration (optional)

If you want to see iTerm2 as the image below you need to enable option 'Load preferences from a custom folder or URL:' in General Tab with path '~/.dotfiles/iterm2'

## Utilities installed
- zsh
- [zgen](https://github.com/tarjoilija/zgen) - A lightweight plugin manager for Zsh.
- git
- node
- [z](https://github.com/rupa/z) - Tracks your most used directories, based on 'frequency'.
- [timedog](https://github.com/nlfiedler/timedog) - Displays the set of files that were saved for any given backup created by Mac OS X Time Machine.
- openssl
- maven
- gradle
- tree
- python
- [httpie](https://github.com/jkbrzt/httpie) - Command line HTTP client.
- [fzf](https://github.com/junegunn/fzf) - A general-purpose command-line fuzzy finder.
- atom
- dockertoolbox
- libreoffice
- sequel-pro
- sts
- [font-fira-mono](https://www.fontsquirrel.com/fonts/fira-mono)

## TODO
- [ ] Demo gif
- [ ] List of more used commands
- [x] ~~How to install~~
- [x] ~~Fix permissions for homebrew before installation~~
- [x] ~~Update brew if it is already installed~~
- [ ] Add selectable list for brew packages
- [x] ~~Brew link unlinked kegs~~
- [x] ~~Add /usr/local/bin/zsh as default shell (chsh)~~
- [x] ~~Input option to change gitconfig data~~
- [x] ~~Split macos-linux options~~
- [x] ~~Improve logs~~
- [x] ~~Set requirements~~
- [x] ~~Write description about the apps and scripts executed~~
- [x] ~~Docker execution at startup optional~~
- [x] ~~Update script~~
- [x] ~~Avoid password if brew permissions are correct~~
- [ ] Uninstall script
- [ ] Update zgen at bootstrap
- [ ] Try to modularize installation script by component with logs on /tmp for issue tracking
- [ ] Add tmux configuration

## Bugs
If you have any problem installing dotfiles, please [open an issue](https://github.com/rcruzper/dotfiles/issues).
