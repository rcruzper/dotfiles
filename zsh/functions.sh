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

function ip-from-instance() {
    aws ec2 describe-instances --filters "{\"Name\":\"tag:Name\", \"Values\":[\"$1\"]}" --query='Reservations[0].Instances[0].PrivateIpAddress' | tr -d '"'
}

function ssh-aws() {
    ssh "${2:=ec2-user}"@"$(ip-from-instance "$1")"
}
