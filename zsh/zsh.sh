#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

# Install zsh
if [ ! $(command -v zsh) ]
then
    info 'Installing zsh'
    brew install zsh
    success 'Installing zsh'
fi

# Set zsh as default shell
if [ -n $SHELL ]
then
    if [ $SHELL != "/usr/local/bin/zsh" ]
    then
        info 'Setting up zsh as default shell'
        if ! grep -q /usr/local/bin/zsh /etc/shells; then
            echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
        fi

        sudo chsh -s "/usr/local/bin/zsh" "$(whoami)"

        success 'Setting up zsh as default shell'
    fi
fi

# Install zinit
if [ ! -f ~/.zinit/bin/zinit.zsh ]
then
    info 'Installing zinit'
    zsh -c "$(sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)")"
    success 'Installing zinit'
else
    info 'Updating zinit'
    zsh -i -c "zi self-update"
    zsh -i -c "zi update"
    success 'Updating zinit'
fi
