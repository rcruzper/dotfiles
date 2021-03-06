# Dotfiles

![](https://raw.githubusercontent.com/rcruzper/dotfiles/master/dotfiles.png)

This is my set of configuration files to get ready in any new machine. If you want to know more about dotfiles, see [dotfiles.github.io](https://dotfiles.github.io/).

## Requirements
- [iTerm 2.9](https://iterm2.com/downloads/beta/iTerm2-2_9_20160510.zip)
- User password is required to fix brew permissions and add zsh as default shell

## Installation

```terminal
git clone --recursive git@github.com:rcruzper/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
scripts/bootstrap.sh
```

If you want to update the configuration, you just need to execute `cd ~/.dotfiles && scripts/bootstrap.sh` again.

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
- libreoffice
- sequel-pro
- sts
- [font-fira-mono](https://www.fontsquirrel.com/fonts/fira-mono)
- [htop](http://hisham.hm/htop/) - A top replacement
- [ag](https://github.com/ggreer/the_silver_searcher) - A code searching tool similar to ack, with a focus on speed.
- vim
    - [vim-plug](https://github.com/junegunn/vim-plug) - A minimalist Vim plugin manager.
    - [vim-airline](https://github.com/vim-airline/vim-airline)
    - [vim-fugitive](https://github.com/tpope/vim-fugitive)
    - [NERDtree](https://github.com/scrooloose/nerdtree)
- ansible
- awscli
- awsebcli
- kubectl
- minikube
- docker for mac
- [dps](https://github.com/rcruzper/dps)

## TODO
- [ ] Update utilities installed
- [ ] Add encrypted files for:
    - [ ] ssh keys and config
    - [ ] docker config
    - [ ] aws credentials
    - [ ] maven settings
    - [ ] Trailer settings
- [ ] Install Alfred, license and workflows
- [ ] Documentation of zsh loading
- [ ] Improve FZF_DEFAULT_OPTS
- [ ] Remove plug.vim from repository and download on every installation
- [ ] Document new theme colors (https://github.com/sindresorhus/iterm2-snazzy)
- [ ] Remove all vim colorscheme references
- [ ] Add selectable list for brew packages

## Bugs
If you have any problem installing dotfiles, please [open an issue](https://github.com/rcruzper/dotfiles/issues).
