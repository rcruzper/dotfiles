#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

# Link only the theme file (not the whole ~/.config/bat) so an existing
# bat `config` is left untouched.
mkdir -p "$HOME/.config/bat/themes"
ln -snf "$DOTFILES_ROOT/bat/themes/rose-pine.tmTheme" "$HOME/.config/bat/themes/rose-pine.tmTheme"

info 'Building bat theme cache'
bat cache --build
success 'Building bat theme cache'
