#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

PACKAGES_FILE="$DOTFILES_ROOT/node/packages.txt"

if [ ! "$(command -v bun)" ]
then
    warn 'bun is not available, skip global node packages'
    exit 0
fi

packages=()
while IFS= read -r line || [ -n "$line" ]
do
    line="${line%%#*}"
    line="$(echo "$line" | xargs)"
    [ -z "$line" ] && continue
    packages+=("$line")
done < "$PACKAGES_FILE"

if [ ${#packages[@]} -eq 0 ]
then
    info 'No global node packages declared'
    exit 0
fi

info 'Installing/Updating global node packages'
bun add --global "${packages[@]}"
success 'Installing/Updating global node packages'
