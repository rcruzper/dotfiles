#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

info 'Installing symlinks'

for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink')
do
dst="$HOME/.$(basename "${src%.*}")"
ln -snf "$src" "$dst"
done

success 'Installing symlinks'
