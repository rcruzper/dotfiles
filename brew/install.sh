#!/bin/sh

if test "$(uname)" = "Darwin"
then
    if test ! $(which brew)
    then
        echo "> Installing Homebrew"
        ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
    else
        echo "> Updating homebrew"
        if [$(find /usr/local -user $(whoami) | wc -l) != $(find /usr/local | wc -l) ]
        then
            sudo chown -R "$USER":admin /usr/local
        fi
        brew update
        echo "> Upgrade formulas"
        brew upgrade
        echo "> Link all formulas"
        brew list -1 | while read line; do brew unlink $line; brew link --overwrite --force $line; done
        echo "> Cleanup old formulas"
        brew cleanup
    fi
fi

return 0
