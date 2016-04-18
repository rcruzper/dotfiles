#!/usr/bin/env bash

source script/logging.sh

operating_system() {
    info "Determining operating system"
    platform="unknown"
    case "$OSTYPE" in
      darwin*)
        platform="OSX"
        ;;
      linux*)
        platform="LINUX"
        ;;
    esac
    success "Operating system determined: $platform"
    echo ''
}

setup_gitconfig() {
    if ! [ -f git/gitconfig.local.symlink ]
    then
      info 'Setup gitconfig'

      git_credential='cache'
      if [ "$(uname -s)" == "Darwin" ]
      then
        git_credential='osxkeychain'
      fi

      user ' - What is your github author name?'
      read -e git_authorname
      user ' - What is your github author email?'
      read -e git_authoremail

      sed -e "s/AUTHORNAME/$git_authorname/g" -e "s/AUTHOREMAIL/$git_authoremail/g" -e "s/GIT_CREDENTIAL_HELPER/$git_credential/g" git/gitconfig.local.symlink.example > git/gitconfig.local.symlink

      success 'Gitconfig'
      echo ''
    fi
}

link_file () {
  local src=$1 dst=$2

  local overwrite= backup= skip=
  local action=

  if [ -f "$dst" -o -d "$dst" -o -L "$dst" ]
  then

    if [ "$overwrite_all" == "false" ] && [ "$backup_all" == "false" ] && [ "$skip_all" == "false" ]
    then

      local currentSrc="$(readlink $dst)"

      if [ "$currentSrc" == "$src" ]
      then

        skip=true;

      else

        user "File already exists: $dst ($(basename "$src")), what do you want to do?\n\
        [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all?"
        read -n 1 action

        case "$action" in
          o )
            overwrite=true;;
          O )
            overwrite_all=true;;
          b )
            backup=true;;
          B )
            backup_all=true;;
          s )
            skip=true;;
          S )
            skip_all=true;;
          * )
            ;;
        esac

      fi

    fi

    overwrite=${overwrite:-$overwrite_all}
    backup=${backup:-$backup_all}
    skip=${skip:-$skip_all}

    if [ "$overwrite" == "true" ]
    then
      rm -rf "$dst"
      success "Removed $dst"
    fi

    if [ "$backup" == "true" ]
    then
      mv "$dst" "${dst}.backup"
      success "Moved $dst to ${dst}.backup"
    fi

    if [ "$skip" == "true" ]
    then
      success "Skipped $src"
    fi
  fi

  if [ "$skip" != "true" ]  # "false" or empty
  then
    ln -s "$1" "$2"
    success "Linked $1 to $2"
  fi
}

install_dotfiles () {
  info 'Installing symlinks'

  local overwrite_all=false backup_all=false skip_all=false

  for src in $(find -H "$DOTFILES_ROOT" -maxdepth 2 -name '*.symlink' -not -path '*.git*')
  do
    dst="$HOME/.$(basename "${src%.*}")"
    link_file "$src" "$dst"
  done

  success 'Symlinks installed'

  echo ''
}

install_brew() {
    if test "$(uname)" = "Darwin"
    then
        info "Installing brew"
        if source brew/install.sh > /tmp/dotfiles-brew-install 2>&1
        then
            success "Homebrew installed"
            echo ''
        else
            fail "Error installing homebrew"
        fi
    fi
}

install_brew_packages() {
    if test "$(uname)" = "Darwin"
    then
        info "Installing homebrew packages"
        cd $DOTFILES_ROOT/brew
        brew bundle > /tmp/dotfiles-brew-bundle 2>&1
        cd $DOTFILES_ROOT
        success "Hombrew packages installed"
        echo ''
    fi
}

setup_zsh() {
    if [ "$SHELL" != "/usr/local/bin/zsh" ]
    then
        info "Setting up zsh as default shell"
        if ! grep -Fxq "/usr/local/bin/zsh" /etc/shells
        then
            echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells
        fi
        sudo chsh -s "/usr/local/bin/zsh" "$(whoami)"
        success "Setup zsh as default shell"
        echo ''
    fi
}

execute_docker_on_launch() {
    if test "$(uname)" = "Darwin"
    then
        if ! [ -f ~/Library/LaunchAgents/com.docker.machine.default.plist ]
        then
            curl -sL http://git.io/vsk46 | \
            sed -e "s?{{docker-machine}}?$(which docker-machine)?" \
            -e "s?{{user-path}}?$(echo $PATH)?" \
            > ~/Library/LaunchAgents/com.docker.machine.default.plist
        fi

        local number=$(launchctl list | grep com.docker.machine.default | wc -l)
        if ! [ $number -gt 0 ]
        then
            info "Execution of docker on startup"
            user "Do you want to execute docker at startup? (y/n)"
            read -n 1 action

            case "$action" in
              y )
                launchctl load ~/Library/LaunchAgents/com.docker.machine.default.plist
                success "Execution of docker at startup"
                ;;
              * )
                ;;
            esac

            echo ''
        fi
    fi
}

operating_system
setup_gitconfig
install_dotfiles
install_brew
install_brew_packages
setup_zsh
execute_docker_on_launch