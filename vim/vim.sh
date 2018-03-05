#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.." > /dev/null
DOTFILES_ROOT=$(pwd -P)

. $DOTFILES_ROOT/scripts/tools/logging.sh --source-only

info 'Installing plug.vim'
mkdir -p ~/.vim
curl -fLo ~/.vim/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
cp $DOTFILES_ROOT/vim/plug.vim ~/.vim
success 'Installing plug.vim'

info 'Updating vim plugins'
vim +PlugUpgrade +PlugUpdate +PlugInstall +qall
success 'Updating vim plugins'