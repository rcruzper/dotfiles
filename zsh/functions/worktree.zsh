# Custom worktree flow (fzf + tmux), sourced from ~/.zshrc. Create popup: prefix + W.
#   wt          create/reattach a worktree + tmux session
#   wt-rm [-f]  close the current task (worktree + branch + session)

function wt() {
  command -v fzf    >/dev/null 2>&1 || { print -u2 "wt: fzf is required"; return 1; }
  command -v zoxide >/dev/null 2>&1 || { print -u2 "wt: zoxide is required"; return 1; }

  # pick repo: zoxide dirs that are git roots
  local repo
  repo=$(
    zoxide query -l 2>/dev/null | while IFS= read -r d; do
      [[ -d "$d/.git" ]] && print -r -- "$d"
    done | fzf --reverse --height=100% --prompt='repo > ' --header='pick a repo (zoxide)'
  )
  [[ -z "$repo" ]] && return 0

  # pick an existing branch (local+remote) or type a new one. The synthetic top row
  # "＋ create «…»" is regenerated live via change:reload; --print-query returns the typed text.
  # The branch list is computed once into a temp file: re-running git on every keystroke
  # made the reload slow and the popup flicker while typing.
  local branches branches_file out
  branches_file=$(mktemp)
  {
    git -C "$repo" for-each-ref --format='%(refname:short)'    refs/heads
    git -C "$repo" for-each-ref --format='%(refname:lstrip=3)' refs/remotes | grep -vx HEAD
  } | awk 'NF && !seen[$0]++' > "$branches_file"
  branches=$(<"$branches_file")
  # --disabled: fzf must not filter the visible list itself — its matcher would hide the
  # "＋ create «old-query»" row the instant the query changes (its text no longer matches),
  # which made the row blink on every keystroke. Filtering runs inside the reload via
  # `fzf --filter`, and reload-sync swaps the finished list in one step.
  out=$(
    print -r -- "$branches" \
      | fzf --print-query --disabled --reverse --height=100% --prompt='branch > ' \
            --header="repo: ${repo:t} · pick a branch or type a new name to create it" \
            --bind "change:reload-sync:{ [ -n {q} ] && printf '＋ create «%s»\n' {q}; fzf --filter {q} < ${(q)branches_file}; true; }"
  )
  rm -f "$branches_file"
  # --print-query output: line 1 = query, line 2 = selection
  local -a lines; lines=("${(@f)out}")
  local query="${lines[1]:-}" pick="${lines[2]:-}" branch mode
  if [[ -n "$pick" ]] && print -r -- "$branches" | grep -qxF -- "$pick"; then
    branch="$pick";  mode="existing"
  else
    branch="$query"; mode="new"
  fi
  [[ -z "$branch" ]] && return 0

  local repo_name worktree_dir checked_out
  repo_name=${repo:t}
  worktree_dir="${repo:h}/${repo_name}-worktrees/${branch}"

  # if the branch is already checked out in a worktree (e.g. develop in the main root),
  # reuse it — git refuses a second checkout of the same branch.
  checked_out=$(git -C "$repo" worktree list --porcelain \
    | awk -v b="refs/heads/$branch" '/^worktree /{w=substr($0,10)} $1=="branch"&&$2==b{print w}')

  if [[ -n "$checked_out" ]]; then
    worktree_dir="$checked_out"
    print -r -- "wt: '$branch' is already checked out in a worktree -> $worktree_dir (reusing it)"
  elif [[ -d "$worktree_dir" ]]; then
    print -r -- "wt: worktree already exists -> $worktree_dir"
  elif [[ "$mode" == "existing" ]]; then
    # DWIM: use the local branch if it exists, else create a local branch tracking the remote
    mkdir -p "${worktree_dir:h}"
    git -C "$repo" worktree add "$worktree_dir" "$branch" || return 1
  else
    # new branch off the remote default (origin/HEAD, fetched); fallbacks: origin/main|master, HEAD
    local base b
    base=$(git -C "$repo" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null)
    if [[ -n "$base" ]]; then
      git -C "$repo" fetch --quiet origin "${base#origin/}" 2>/dev/null
    else
      for b in main master; do
        git -C "$repo" show-ref --quiet --verify "refs/remotes/origin/$b" && { base="origin/$b"; break; }
      done
      [[ -z "$base" ]] && base=HEAD
    fi
    print -r -- "wt: new branch '${branch}' from '${base}'"
    mkdir -p "${worktree_dir:h}"
    git -C "$repo" worktree add --no-track -b "$branch" "$worktree_dir" "$base" || return 1
  fi

  print -r -- "wt: worktree at $worktree_dir  (branch ${branch}, mode ${mode})"

  # copy .env* and .claude/settings.local.json into the worktree if present (never overwrite)
  local f
  for f in .env .env.local .env.test .claude/settings.local.json; do
    if [[ -f "$repo/$f" && ! -f "$worktree_dir/$f" ]]; then
      mkdir -p "$worktree_dir/${f:h}"
      cp "$repo/$f" "$worktree_dir/$f"
    fi
  done

  # tmux session (idempotent): 1:claude 2:editor 3:sh
  local session="${repo_name}/${branch}"
  session=${session//[.:]/-}   # tmux session names can't contain . or :
  if ! tmux has-session -t "=$session" 2>/dev/null; then
    tmux new-session -d -s "$session" -c "$worktree_dir" -n claude
    tmux new-window  -t "$session:" -c "$worktree_dir" -n editor
    tmux new-window  -t "$session:" -c "$worktree_dir" -n sh
    [[ -f "$worktree_dir/pnpm-lock.yaml" ]] && tmux send-keys -t "$session:3" 'pnpm install' C-m
    tmux send-keys -t "$session:2" 'nvim'   C-m
    tmux send-keys -t "$session:1" 'claude' C-m
    tmux select-window -t "$session:1"
  fi

  # jump to it: switch inside tmux, attach outside
  if [[ -n "${TMUX:-}" ]]; then
    tmux switch-client -t "$session"
  else
    tmux attach -t "$session"
  fi
}

# wt-rm [-f] - close the current task in-place: remove worktree + local branch + session,
# then return to the repo's base session. Without -f: requires a MERGED PR and a clean worktree.
function wt-rm() {
  local force=""
  [[ "${1:-}" == "-f" ]] && force="--force"

  local worktree_dir main_root repo_name branch session state
  worktree_dir=$(git rev-parse --show-toplevel 2>/dev/null) || {
    print -u2 "wt-rm: not inside a git repo"; return 1
  }
  main_root=$(git worktree list --porcelain | sed -n '1s/^worktree //p')
  if [[ "$worktree_dir" == "$main_root" ]]; then
    print -u2 "wt-rm: you are in the main worktree, not in a task"; return 1
  fi
  repo_name=${main_root:t}
  branch=$(git rev-parse --abbrev-ref HEAD)
  session="${repo_name}/${branch}"       # same name wt used (full branch, may contain '/')
  session=${session//[.:]/-}

  # guard: without -f, require the branch's PR to be MERGED
  if [[ -z "$force" ]]; then
    state=$(gh pr view "$branch" --json state -q .state 2>/dev/null)
    if [[ "$state" != "MERGED" ]]; then
      print -u2 "wt-rm: PR for '$branch' is not MERGED (state: ${state:-no PR}); use 'wt-rm -f' to force"
      return 1
    fi
  fi

  # must leave the worktree before removing it
  builtin cd "$main_root" || return 1
  git worktree remove $force "$worktree_dir" || return 1
  git branch -D "$branch" 2>/dev/null

  # prune empty parent dirs under <repo>-worktrees (branches with '/')
  local d="${worktree_dir:h}"
  while [[ "$d" == *-worktrees/* || "$d" == *-worktrees ]]; do
    rmdir "$d" 2>/dev/null || break
    d="${d:h}"
  done

  # land on another live session, then kill the task's
  # (relies on tmux `detach-on-destroy off`, so killing it doesn't detach you)
  if [[ -n "${TMUX:-}" ]]; then
    local -a candidates
    local s target=""
    # every other live session, most-recently-attached first
    candidates=("${(@f)$(tmux list-sessions -F '#{session_last_attached} #{session_name}' 2>/dev/null \
      | sort -rn | cut -d' ' -f2- | grep -vxF -- "$session")}")

    # prefer a sibling of the same repo ('<repo>' or '<repo>/<branch>')
    for s in $candidates; do
      [[ "$s" == "$repo_name" || "$s" == "${repo_name}/"* ]] && { target="$s"; break }
    done
    # otherwise whatever was used most recently
    [[ -z "$target" ]] && target="${candidates[1]:-}"

    if [[ -n "$target" ]]; then
      tmux switch-client -t "=$target"
    else
      # nothing else is open: killing the last session would take the server down,
      # so fall back to the repo's base session purely to keep tmux alive
      tmux new-session -d -s "$repo_name" -c "$main_root"
      tmux switch-client -t "=$repo_name"
      target="$repo_name"
    fi
  fi
  tmux kill-session -t "=$session" 2>/dev/null

  print -r -- "wt-rm: closed '$branch' (worktree, branch and session removed)${target:+ -> $target}"
}
