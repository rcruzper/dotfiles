#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

# Install sdkman
if [ ! -f ~/.sdkman/bin/sdkman-init.sh ]
then
    info 'Installing sdkman'
    curl -s "https://get.sdkman.io" | bash
    ln -sf "$DOTFILES_ROOT/sdkman/config" "$HOME/.sdkman/etc/config"
    zsh -i -c 'export SDKMAN_DIR="$HOME/.sdkman" && \
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && \
        source "$HOME/.sdkman/bin/sdkman-init.sh" && \
        sdk install java'
    success 'Installing sdkman'
else
#    info 'Updating java from sdkman'
#    ln -sf "$DOTFILES_ROOT/sdkman/config" "$HOME/.sdkman/etc/config"
#    zsh -i -c 'export SDKMAN_DIR="$HOME/.sdkman" && \
#        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && \
#        source "$HOME/.sdkman/bin/sdkman-init.sh" && \
#        sdk install java'
#    success 'Updating java from sdkman'
    info 'Flushing sdkman'
    zsh -i -c 'export SDKMAN_DIR="$HOME/.sdkman" && \
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && \
        source "$HOME/.sdkman/bin/sdkman-init.sh" && \
        sdk flush && \
        sdk flush broadcast'
    success 'Flushing sdkman'
    info 'Updating sdkman'
    zsh -i -c 'export SDKMAN_DIR="$HOME/.sdkman" && \
        [[ -s "$HOME/.sdkman/bin/sdkman-init.sh" ]] && \
        source "$HOME/.sdkman/bin/sdkman-init.sh" && \
        sdk selfupdate && \
        sdk update'
    success 'Updating sdkman'
fi
