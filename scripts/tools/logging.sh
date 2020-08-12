#!/usr/bin/env bash

set -euo pipefail

#green=$(tput setaf 2)
#yellow=$(tput setaf 3)
#blue=$(tput setaf 4)
#reset=$(tput sgr0)

function info() {
    printf "[ .. ] %s\n" "$@"
}

function success() {
    printf "[ OK ] %s\n\n" "$@"
}

function user() {
    printf "[ ?? ] %s\n" "$@"
}
