function sdk() {
   fname=$(declare -f -F infer_platform)

  [ -n "$fname" ] || unset -f sdk && source "$HOME/.sdkman/bin/sdkman-init.sh"

  sdk $@
}

function z() {
  fname=$(declare -f -F __zoxide_z)

  [ -n "$fname" ] || eval "$(zoxide init zsh --no-aliases)"

  __zoxide_z "$1"
}

function nvm() {
  [ -n "$NVM_DIR" ] || unset -f nvm && source "/opt/homebrew/opt/nvm/nvm.sh" && source "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

  nvm $@
}

# aws functions
function ip-from-instance() {
    aws ec2 describe-instances --filters "{\"Name\":\"tag:Name\", \"Values\":[\"$1\"]}" --query='Reservations[0].Instances[0].PrivateIpAddress' | tr -d '"'
}

function ssh-aws() {
    ssh "${2:=ec2-user}"@"$(ip-from-instance "$1")"
}

# dbtunnel - open an SSM port-forwarding tunnel to an environment database.
# Settings live in ~/.aws/config, not here. The profile that declares
# dbtunnel_env=<env> also provides dbtunnel_bastion_tag, dbtunnel_local_port
# and either dbtunnel_cluster_id or dbtunnel_global_cluster.
# Logs in to SSO only when the cached session can no longer be refreshed.
# Usage: dbtunnel <env>   (env = the dbtunnel_env value of an aws profile)
function dbtunnel() {
    if [[ -z "${1:-}" ]]; then
        echo "usage: dbtunnel <env>   (env = the dbtunnel_env value of an aws profile)" >&2
        return 1
    fi

    local env="$1"
    local profile region bastion_tag local_port cluster_id global_cluster

    if ! command -v session-manager-plugin >/dev/null 2>&1; then
        echo "dbtunnel: session-manager-plugin is not installed." >&2
        return 1
    fi

    local -a profiles
    profiles=(${(f)"$(aws configure list-profiles)"})
    local candidate
    for candidate in "${profiles[@]}"; do
        if [[ "$(aws configure get dbtunnel_env --profile "$candidate" 2>/dev/null)" == "$env" ]]; then
            profile="$candidate"
            break
        fi
    done
    if [[ -z "$profile" ]]; then
        echo "dbtunnel: no profile in ~/.aws/config declares dbtunnel_env=$env." >&2
        return 1
    fi

    region=$(aws configure get region --profile "$profile" 2>/dev/null)
    bastion_tag=$(aws configure get dbtunnel_bastion_tag --profile "$profile" 2>/dev/null)
    local_port=$(aws configure get dbtunnel_local_port --profile "$profile" 2>/dev/null)
    cluster_id=$(aws configure get dbtunnel_cluster_id --profile "$profile" 2>/dev/null)
    global_cluster=$(aws configure get dbtunnel_global_cluster --profile "$profile" 2>/dev/null)

    if [[ -z "$region" || -z "$bastion_tag" || -z "$local_port" ]]; then
        echo "dbtunnel: profile $profile needs region, dbtunnel_bastion_tag and dbtunnel_local_port." >&2
        return 1
    fi
    if [[ -z "$cluster_id" && -z "$global_cluster" ]]; then
        echo "dbtunnel: profile $profile needs dbtunnel_cluster_id or dbtunnel_global_cluster." >&2
        return 1
    fi

    if nc -z localhost "$local_port" >/dev/null 2>&1; then
        echo "dbtunnel: localhost:$local_port is busy. The tunnel is probably open already." >&2
        return 1
    fi

    if ! aws sts get-caller-identity --profile "$profile" >/dev/null 2>&1; then
        echo "==> SSO session cannot be refreshed. Opening the browser."
        aws sso login --profile "$profile" || return 1
    fi

    echo "==> Resolving the bastion ($bastion_tag)"
    local instance_id
    instance_id=$(aws ec2 describe-instances \
        --profile "$profile" \
        --region "$region" \
        --filters "Name=tag:Name,Values=$bastion_tag" "Name=instance-state-name,Values=running" \
        --query 'Reservations[0].Instances[0].InstanceId' \
        --output text)
    if [[ -z "$instance_id" || "$instance_id" == "None" ]]; then
        echo "dbtunnel: no running bastion tagged $bastion_tag." >&2
        return 1
    fi

    echo "==> Resolving the database endpoint"
    local db_host
    if [[ -n "$global_cluster" ]]; then
        db_host=$(aws rds describe-global-clusters \
            --profile "$profile" \
            --region "$region" \
            --global-cluster-identifier "$global_cluster" \
            --query 'GlobalClusters[0].Endpoint' \
            --output text)
    else
        db_host=$(aws rds describe-db-clusters \
            --profile "$profile" \
            --region "$region" \
            --db-cluster-identifier "$cluster_id" \
            --query 'DBClusters[0].Endpoint' \
            --output text)
    fi
    if [[ -z "$db_host" || "$db_host" == "None" ]]; then
        echo "dbtunnel: could not resolve the $env database endpoint." >&2
        return 1
    fi

    echo "==> $env: localhost:$local_port -> $db_host:5432 (bastion $instance_id)"
    aws ssm start-session \
        --profile "$profile" \
        --region "$region" \
        --target "$instance_id" \
        --document-name AWS-StartPortForwardingSessionToRemoteHost \
        --parameters "portNumber=5432,localPortNumber=$local_port,host=$db_host"
}

# git functions

# Check if main exists and use instead of master
function git_main_branch() {
  command git rev-parse --git-dir &>/dev/null || return
  local ref
  for ref in refs/{heads,remotes/{origin,upstream}}/{main,trunk,mainline,default}; do
    if command git show-ref -q --verify $ref; then
      echo ${ref:t}
      return
    fi
  done
  echo master
}

# gcheckout - checkout local|remote branch
function gcheckout() {
    if [[ -n $1 ]] then
        git checkout -b "$@"
    else
        local branches branch
        branches=$(git branch --all | grep -v HEAD) &&
        branch=$(echo "$branches" | fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
        git checkout $(echo "$branch" | sed "s/.* //" | sed "s#remotes/[^/]*/##")
    fi
}

# gmerge - merge local|remote branch
function gmerge() {
    if [[ -n $1 ]] then
        git merge "$@"
    else
        local branches branch
        branches=$(git branch --all | grep -v HEAD) &&
        branch=$(echo "$branches" | fzf-tmux -d $(( 2 + $(wc -l <<< "$branches") )) +m) &&
        git merge $(echo "$branch" | sed "s/.* //")
    fi
}

# gfix - git commit -a --fixup
function gfix() {
    local commits commitId
    commits=$(git log --oneline --decorate)
    while read -r commit; do
        if [[ $commit != *fixup\!* ]]; then
            commitId=$(echo $commit | awk '{print $1;}')
            git commit -a --fixup $commitId
            break
        fi
    done <<< "$commits"
}

# grauto - git rebase -i --autosquash
function grauto() {
    local commits
    commits=$(git log --oneline --decorate)
    local counter=0
    while read -r commit; do
        if [[ $commit == *fixup\!* ]]; then
            counter=$((counter+1))
        else
            GIT_SEQUENCE_EDITOR=: git rebase -i --autosquash HEAD~$((counter+1))
            break
        fi
    done <<< "$commits"
}

# gcshow - get git commit SHA-1
function gcshow() {
    local commits commit
    commits=$(git log --color=always --pretty=oneline --abbrev-commit --reverse) &&
    commit=$(echo "$commits" | fzf --tac +s +m -e --ansi --reverse) &&
    echo -n $(echo "$commit" | sed "s/ .*//")
}

# delete remote branches
function gdr() {
    git branch -r --sort=committerdate | sed 's|origin/||g' | fzf --multi | xargs -I '{}' git push origin --delete refs/heads/{}
}

function lf() {
    fzf --preview 'bat --style=numbers --color=always {}' | xargs -n 1 nvim
}

# change between cloud environments
function sw() {
    case "$1" in
        *case1*)
        ;;
        *case2*)
        ;;
    esac
}

# remove local branches already merged into develop branch
function ghdb() {
    git branch --format='%(refname:short)' | grep -vE '^(develop|main)$' | while read b; do
        state=$(gh pr view "$b" --json state -q .state 2>/dev/null)
        [ "$state" = "MERGED" ] && git branch -D "$b"
    done
}

# remove remote branches already merged into default branch
function gdrm() {
    local DEFAULT_BRANCH
    DEFAULT_BRANCH=$(git symbolic-ref refs/remotes/origin/HEAD | cut -f4 -d/)
    for branch in $(git branch -r --merged $DEFAULT_BRANCH | grep origin | grep -v develop | grep -v $DEFAULT_BRANCH); do
        git push origin --delete "${branch#*/}"
        #echo "${branch#*/}"
    done
}
