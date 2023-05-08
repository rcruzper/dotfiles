#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

info 'Configuring starship'

mkdir -p ~/.config
ln -snf "$DOTFILES_ROOT"/starship/starship.toml ~/.config/starship.toml

success 'Configuring starship'
