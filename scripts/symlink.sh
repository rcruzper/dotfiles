#!/usr/bin/env bash

set -euo pipefail

cd "$(dirname "$0")/.." > /dev/null
DOTFILES_ROOT=$(pwd -P)

. $DOTFILES_ROOT/scripts/tools/logging.sh --source-only

info 'Installing symlinks'

for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink')
do
dst="$HOME/.$(basename "${src%.*}")"
ln -sf "$src" "$dst"
done

success 'Installing symlinks'
