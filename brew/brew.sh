#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

if [ ! "$(command -v brew)" ]
then
    info 'Installing brew'
    /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    success 'Installing brew'

    info 'Installing iterm2'
    brew cask install iterm2
    success 'Installing iterm2'
else
    info 'Updating brew'
    brew update
    success 'Updating brew'
    info 'Upgrading brew formulae'
    brew upgrade --ignore-pinned
    # TODO: remove from here because if the intellij app is not installed, it fails
    # brew cask upgrade intellij-idea
    success 'Upgrading brew formulae'
fi

info 'Installing homebrew bundle packages'
brew bundle install -v --file="$DOTFILES_ROOT/brew/Brewfile"
success 'Installing homebrew bundle packages'

#info 'Cleaning up old formulae'
#brew cleanup -s
#success 'Cleaning up old formulae'

#TODO show brew doctor at the end
