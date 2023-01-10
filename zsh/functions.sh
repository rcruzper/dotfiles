function load_sdk() {
  fname=$(declare -f -F sdk)

  [ -n "$fname" ] || source "$HOME/.sdkman/bin/sdkman-init.sh"

  sdk "$1"
}

function z() {
  fname=$(declare -f -F sdk)

  [ -n "$fname" ] || eval "$(zoxide init zsh --no-aliases)"

  __zoxide_z "$1"
}
