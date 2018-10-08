#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.." > /dev/null
DOTFILES_ROOT=$(pwd -P)

. $DOTFILES_ROOT/scripts/tools/logging.sh --source-only

