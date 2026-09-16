#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

ln -snf "$DOTFILES_ROOT/tmux/tmux" "$HOME/.config/tmux"

TPM_DIR="$HOME/.config/tmux/plugins/tpm"

if [ ! -d "$TPM_DIR" ]; then
    info 'Installing tmux plugin manager (tpm)'
    git clone --depth 1 https://github.com/tmux-plugins/tpm "$TPM_DIR"
    success 'Installing tmux plugin manager (tpm)'
else
    info 'Updating tmux plugin manager (tpm)'
    git -C "$TPM_DIR" pull --ff-only
    success 'Updating tmux plugin manager (tpm)'
fi

info 'Installing missing tmux plugins'
"$TPM_DIR/bin/install_plugins"
success 'Installing missing tmux plugins'

info 'Updating tmux plugins'
"$TPM_DIR/bin/update_plugins" all || warn 'Some tmux plugins failed to update'
success 'Updating tmux plugins'

info 'Cleaning removed tmux plugins'
"$TPM_DIR/bin/clean_plugins" || warn 'Some tmux plugins could not be removed'
success 'Cleaning removed tmux plugins'

