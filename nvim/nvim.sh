#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

ln -snf "$DOTFILES_ROOT/nvim/nvim" "$HOME/.config/nvim"

info 'Updating neovim plugins'
nvim --headless "+Lazy! sync" +qa
success 'Updating neovim plugins'
