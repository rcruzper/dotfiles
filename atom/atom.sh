#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.." > /dev/null
DOTFILES_ROOT=$(pwd -P)

. $DOTFILES_ROOT/scripts/tools/logging.sh --source-only

info 'Installing atom packages'
apm install --packages-file $DOTFILES_ROOT/atom/package-list.txt
apm upgrade --no-confirm
success 'Installing atom packages'