#!/usr/bin/env bash

#
# Entry point of the dotfiles installation. Run it with `make`.
#
# Environment variables:
#   VERBOSE=1     show the full output of every component
#   KEEP_GOING=1  continue even when a critical component fails
#   NO_COLOR=1    disable colours
#
# Exit code: 0 when no component failed, 1 otherwise.
#

set -uo pipefail

cd "$(dirname "$0")/.." > /dev/null
DOTFILES_ROOT=$(pwd -P)
export DOTFILES_ROOT

VERBOSE="${VERBOSE:-0}"
KEEP_GOING="${KEEP_GOING:-0}"

source "$DOTFILES_ROOT/scripts/tools/runner.sh"

# Component registry
#
#   name     : label in the output and name of the log file
#   script   : installer, relative to the repository root
#   requires : comma separated binaries
#   flags    : `critical` stops the installation when the component fails
#
COMPONENTS=(
    # name      script                     requires   flags
    "macos      macos/macos.sh             -          -"
    "brew       brew/brew.sh               -          critical"
    "node       node/node.sh               bun        -"
    "symlink    scripts/symlink.sh         -          -"
    "zsh        zsh/zsh.sh                 brew,zsh   -"
    "starship   starship/starship.sh       -          -"
    "aerospace  aerospace/aerospace.sh     -          -"
    "ghostty    ghostty/ghostty.sh         -          -"
    "nvim       nvim/nvim.sh               nvim       -"
    "tmux       tmux/tmux.sh               tmux,git   -"
    "bat        bat/bat.sh                 bat        -"
)

trap 'printf "\n"; trap - INT TERM; kill 0' INT TERM

start_run "${#COMPONENTS[@]}"

aborted=''
index=0
total=${#COMPONENTS[@]}

for entry in "${COMPONENTS[@]}"
do
    index=$((index + 1))
    read -r name script requires flags <<< "$entry"

    if run_component "$index" "$total" "$name" "$script" "$requires"
    then
        continue
    fi

    if [ "$flags" = 'critical' ] && [ "$KEEP_GOING" != '1' ]
    then
        aborted="$name"
        break
    fi
done

finish_run "$aborted"
