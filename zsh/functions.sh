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
  [ -n "$NVM_DIR" ] || unset -f nvm && source "/usr/local/opt/nvm/nvm.sh" && source "/usr/local/opt/nvm/etc/bash_completion.d/nvm"

  nvm $@
}

# aws functions
function ip-from-instance() {
    aws ec2 describe-instances --filters "{\"Name\":\"tag:Name\", \"Values\":[\"$1\"]}" --query='Reservations[0].Instances[0].PrivateIpAddress' | tr -d '"'
}

function ssh-aws() {
    ssh "${2:=ec2-user}"@"$(ip-from-instance "$1")"
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
