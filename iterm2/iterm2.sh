#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

info 'Configuring iterm2'

defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$DOTFILES_ROOT/iterm2"
defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true

success 'Configuring iterm2'

