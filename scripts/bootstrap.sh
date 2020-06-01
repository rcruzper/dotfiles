#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.." > /dev/null
DOTFILES_ROOT=$(pwd -P)

. $DOTFILES_ROOT/scripts/tools/logging.sh --source-only

$DOTFILES_ROOT/macos/macos.sh
$DOTFILES_ROOT/git/git.sh
$DOTFILES_ROOT/brew/brew.sh
$DOTFILES_ROOT/zsh/zsh.sh
$DOTFILES_ROOT/scripts/symlink.sh
$DOTFILES_ROOT/vim/vim.sh
