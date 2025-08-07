#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

# Install zsh
#if [ ! "$(command -v zsh)" ]
#then
#    info 'Installing zsh'
#    brew install zsh
#    success 'Installing zsh'
#fi

# Set zsh as default shell
if [[ -n $SHELL ]]
then
    if [ "$SHELL" != "/bin/zsh" ]
    then
        info 'Setting up zsh as default shell'
        if ! grep -q /bin/zsh /etc/shells; then
            echo "/bin/zsh" | sudo tee -a /etc/shells
        fi

        sudo chsh -s "/bin/zsh" "$(whoami)"

        success 'Setting up zsh as default shell'
    fi
fi

# Install zinit
if [ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]
then
    info 'Installing zinit'
    zsh -c "$(sh -c "$(curl --fail --show-error --silent --location https://raw.githubusercontent.com/zdharma-continuum/zinit/HEAD/scripts/install.sh)")"
    success 'Installing zinit'
else
    info 'Updating zinit'
    zsh -i -c "zi self-update"
    zsh -i -c "zi update"
    success 'Updating zinit'
fi
