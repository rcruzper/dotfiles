#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

info 'Configuring ghostty'

mkdir -p ~/.config/ghostty
ln -snf "$DOTFILES_ROOT"/ghostty/config ~/.config/ghostty/config

success 'Configuring ghostty'
