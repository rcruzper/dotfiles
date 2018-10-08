function ip_from_instance() {
    echo $(aws ec2 describe-instances --filters "{\"Name\":\"tag:Name\", \"Values\":[\"$1\"]}" --query='Reservations[0].Instances[0].PrivateIpAddress' | tr -d '"')
}

function ssh-aws() {
    ssh "${2:=ec2-user}"@$(ip_from_instance "$1")
}
