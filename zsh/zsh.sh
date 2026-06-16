#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

# Update antidote bundles
ANTIDOTE_SCRIPT="$(brew --prefix antidote 2>/dev/null)/share/antidote/antidote.zsh"
if [[ -f "$ANTIDOTE_SCRIPT" ]]; then
    info 'Updating antidote bundles'
    zsh -c "source '$ANTIDOTE_SCRIPT' && antidote update"
    success 'Updating antidote bundles'
fi
