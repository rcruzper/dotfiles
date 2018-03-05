#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.." > /dev/null
DOTFILES_ROOT=$(pwd -P)

. $DOTFILES_ROOT/scripts/tools/logging.sh --source-only

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

# Install zplug
if [ ! -f /usr/local/opt/zplug/autoload/zplug ]
then
    info 'Installing zplug'
    zsh -c "curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh"
    success 'Installing zplug'
fi
