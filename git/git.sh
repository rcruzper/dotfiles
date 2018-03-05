#!/usr/bin/env bash

set -e

cd "$(dirname "$0")/.." > /dev/null
DOTFILES_ROOT=$(pwd -P)

. $DOTFILES_ROOT/scripts/tools/logging.sh --source-only

# gitconfig.local file creation
if [ ! -f $DOTFILES_ROOT/git/gitconfig.local.symlink ]
then
    info 'Setting up gitconfig'

    git_author_name_text=$(user ' - What is your git author name?')
    read -p "$git_author_name_text " git_author_name
    git_author_email_text=$(user ' - What is your git author email?')
    read -p "$git_author_email_text " git_author_email

    sed -e "s/AUTHORNAME/$git_author_name/g" -e "s/AUTHOREMAIL/$git_author_email/g" $DOTFILES_ROOT/git/gitconfig.local.symlink.example > $DOTFILES_ROOT/git/gitconfig.local.symlink

    success 'Setting up gitconfig'
fi
