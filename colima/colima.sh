#!/usr/bin/env bash

set -euo pipefail

source "$DOTFILES_ROOT/scripts/tools/logging.sh"

info 'Configuring colima'

# Colima reads the template only when it creates an instance. To apply a
# change to an existing VM, run `colima delete` and start it again.
mkdir -p ~/.colima/_templates
ln -snf "$DOTFILES_ROOT"/colima/colima.yaml ~/.colima/_templates/default.yaml

# Let the docker CLI find the compose and buildx plugins installed by brew
config=~/.docker/config.json
plugins="$(brew --prefix)/lib/docker/cli-plugins"

mkdir -p ~/.docker
[ -f "$config" ] || echo '{}' > "$config"

jq --arg dir "$plugins" \
    '.cliPluginsExtraDirs = ((.cliPluginsExtraDirs // []) - [$dir] + [$dir])' \
    "$config" > "$config.tmp"
mv "$config.tmp" "$config"

# Leftovers of Docker Desktop, once it is uninstalled
if [ ! -d /Applications/Docker.app ]
then
    jq 'if .credsStore == "desktop" then .credsStore = "osxkeychain" else . end' \
        "$config" > "$config.tmp"
    mv "$config.tmp" "$config"

    find ~/.docker/cli-plugins -type l ! -exec test -e {} \; -delete 2> /dev/null || true
fi

# Start the VM now and at every login
if ! colima status > /dev/null 2>&1
then
    brew services start colima
fi

success 'Configuring colima'
