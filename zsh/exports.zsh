export GOPATH=~/develop/go

export EDITOR='vim'

export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export HOMEBREW_NO_ANALYTICS=true

export FZF_DEFAULT_OPTS="--height 60% --color bg+:240"

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

export BAT_THEME="Dracula"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=30000
export SAVEHIST=30000

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"

paths=(
  "$GOPATH/bin"
  "/usr/local/opt/gnu-sed/libexec/gnubin" # Use gnu-sed (mac version is from BSD 2005)
  "/usr/local/opt/make/libexec/gnubin" # Use gnu-make
  "/usr/local/bin"
  "/usr/bin"
  "/usr/local/sbin"
  "/bin"
  "/usr/sbin"
  "/sbin"
  "$HOME/.local/bin" # pipx binaries
)

PATH=$(
  IFS=":"
  echo "${paths[*]}"
)

export PATH
