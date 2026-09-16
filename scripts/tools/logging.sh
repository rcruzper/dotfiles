#!/usr/bin/env bash

if [ -n "${NO_COLOR:-}" ] || [ ! -t 1 ] || [ -z "${TERM:-}" ] || [ "${TERM:-}" = "dumb" ]
then
    c_red=''
    c_green=''
    c_yellow=''
    c_blue=''
    c_reset=''
else
    c_red=$'\033[0;31m'
    c_green=$'\033[0;32m'
    c_yellow=$'\033[0;33m'
    c_blue=$'\033[0;34m'
    c_reset=$'\033[0m'
fi

function info() {
    printf "[ %s..%s ] %s\n" "$c_blue" "$c_reset" "$*"
}

function success() {
    printf "[ %sOK%s ] %s\n\n" "$c_green" "$c_reset" "$*"
}

function user() {
    printf "[ %s??%s ] %s\n" "$c_yellow" "$c_reset" "$*"
}

function warn() {
    printf "[ %s!!%s ] %s\n" "$c_yellow" "$c_reset" "$*"
}

function error() {
    printf "[ %sKO%s ] %s\n" "$c_red" "$c_reset" "$*" >&2
}
