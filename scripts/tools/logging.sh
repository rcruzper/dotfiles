#!/usr/bin/env bash

set -euo pipefail

green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
reset=$(tput sgr0)

function info() {
    printf "[ ${blue}..${reset} ] %s\n" "$@"
}

function success() {
    printf "[ ${green}OK${reset} ] %s\n\n" "$@"
}

function user() {
    printf "[ ${yellow}??${reset} ] %s\n" "$@"
}
