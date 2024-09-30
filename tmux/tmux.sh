#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

ln -snf "$DOTFILES_ROOT/tmux/tmux" "$HOME/.config/tmux"

# nvim --headless "+Lazy! sync" +qa
# success 'Updating neovim plugins'

