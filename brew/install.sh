#!/bin/sh

if test "$(uname)" = "Darwin"
then
    if test ! $(which brew)
    then
        echo "> Installing Homebrew"
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "> Updating homebrew"
        sudo chown -R "$USER":admin /usr/local  # it needs test
        brew update
        brew upgrade
    fi
fi

return 0
