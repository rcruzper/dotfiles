#!/usr/bin/env bash

set -euo pipefail

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

# Install zinit
if [ ! -f ~/.zinit/bin/zinit.zsh ]
then
    info 'Installing zinit'
    zsh -c "$(sh -c "$(curl -fsSL https://raw.githubusercontent.com/zdharma/zinit/master/doc/install.sh)")"
    success 'Installing zinit'
else
    # No consigo usar zplugin dentro de un script porque es una función
    # info 'Updating zplugin'
    #autoload gcheckout
    #type gcheckout
    #zsh -c "gcheckout"
    #zsh -c "$(zplugin self-update)"
    #zplugin update --all
    #success 'Updating zplugin'
fi
