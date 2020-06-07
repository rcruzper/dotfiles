#!/usr/bin/env bash

set -e

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

info 'Installing plug.vim'
mkdir -p ~/.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cp "$DOTFILES_ROOT/vim/plug.vim" ~/.vim
success 'Installing plug.vim'

info 'Updating vim plugins'
vim +PlugUpgrade +PlugUpdate +PlugInstall +qall
success 'Updating vim plugins'