#!/usr/bin/env bash

set -euo pipefail

green=$(tput setaf 2)
yellow=$(tput setaf 3)
blue=$(tput setaf 4)
reset=$(tput sgr0)

info() {
    echo "[ ${blue}..${reset} ] " $@
}

success() {
    echo "[ ${green}OK${reset} ] " $@
}

user() {
    echo "[ ${yellow}??${reset} ] " $@
}
