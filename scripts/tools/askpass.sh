#!/usr/bin/env bash
#
# Password helper for sudo. runner.sh puts this file in SUDO_ASKPASS.
#
# Homebrew adds `-A` to sudo when SUDO_ASKPASS is present. sudo then runs
# this helper at the moment that it needs the password, and reads the
# password from the output. A dialog asks for it, so the spinner of the
# runner does not hide the prompt. The password never goes to a file.
#
# When the user cancels the dialog, osascript fails, and sudo fails too.

osascript \
    -e 'display dialog "A component of the dotfiles installation needs your password." with title "dotfiles" default answer "" with hidden answer' \
    -e 'text returned of result'
