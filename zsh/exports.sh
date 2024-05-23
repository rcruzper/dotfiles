export GOPATH=~/develop/go

export EDITOR='nvim'
export KUBE_EDITOR='nvim'

export HOMEBREW_CASK_OPTS="--appdir=/Applications"
export HOMEBREW_NO_ANALYTICS=true

export FZF_DEFAULT_OPTS="--height 60% --color bg+:240"

export DOTFILES_PATH="$HOME/.dotfiles"

export BAT_THEME="Dracula"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=30000
export SAVEHIST=30000

export FZF_DEFAULT_COMMAND='fd --type f'
# export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export FZF_CTRL_T_COMMAND="git --no-pager diff --name-only; git ls-files --others --exclude-standard"

paths=(
  "$GOPATH/bin"
  "/opt/homebrew/opt/gnu-sed/libexec/gnubin" # Use gnu-sed (mac version is from BSD 2005)
  "/opt/homebrew/opt/make/libexec/gnubin" # Use gnu-make
  "/opt/homebrew/sbin"
  "/opt/homebrew/bin"
  "/usr/local/bin"
  "/usr/bin"
  "/usr/local/sbin"
  "/bin"
  "/usr/sbin"
  "/sbin"
  "$HOME/.local/bin" # pipx binaries
  "$HOME/.cargo/bin"
)

PATH=$(
  IFS=":"
  echo "${paths[*]}"
)

export PATH
