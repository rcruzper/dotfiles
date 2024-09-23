#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

info 'Configuring aerospace'

mkdir -p ~/.config/aerospace
ln -snf "$DOTFILES_ROOT"/aerospace/aerospace.toml ~/.config/aerospace/aerospace.toml

success 'Configuring aerospace'

