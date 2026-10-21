#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

export HOMEBREW_CURLRC="$DOTFILES_ROOT/brew/curlrc"

if [ ! "$(command -v brew)" ]
then
    info 'Installing brew'
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    success 'Installing brew'

    info 'Installing iterm2'
    brew install --cask iterm2
    success 'Installing iterm2'
else
    info 'Updating brew'
    brew update
    success 'Updating brew'

    info 'Upgrading brew formulae'
    brew upgrade --formula -y || warn 'One formula or more did not upgrade'
    success 'Upgrading brew formulae'

    info 'Upgrading brew casks'
    brew upgrade --cask -y || warn 'One cask or more did not upgrade'
    success 'Upgrading brew casks'
fi

info 'Installing homebrew bundle packages'
brew bundle install -v --file="$DOTFILES_ROOT/brew/Brewfile"
success 'Installing homebrew bundle packages'
