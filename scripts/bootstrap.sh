#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.." > /dev/null
DOTFILES_ROOT=$(pwd -P)

export DOTFILES_ROOT

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

"$DOTFILES_ROOT/macos/macos.sh"
"$DOTFILES_ROOT/git/git.sh"
"$DOTFILES_ROOT/sdkman/sdkman.sh"
"$DOTFILES_ROOT/brew/brew.sh"
"$DOTFILES_ROOT/zsh/zsh.sh"
"$DOTFILES_ROOT/scripts/symlink.sh"
"$DOTFILES_ROOT/starship/starship.sh"
"$DOTFILES_ROOT/aerospace/aerospace.sh"
# "$DOTFILES_ROOT/vim/vim.sh"
"$DOTFILES_ROOT/nvim/nvim.sh"
"$DOTFILES_ROOT/tmux/tmux.sh"

