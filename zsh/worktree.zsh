# Custom worktree flow (fzf + tmux), sourced from ~/.zshrc. Create popup: prefix + W.
#   wt          create/reattach a worktree + tmux session
#   wt-rm [-f]  close the current task (worktree + branch + session)

function wt() {
  command -v fzf    >/dev/null 2>&1 || { print -u2 "wt: necesita fzf"; return 1; }
  command -v zoxide >/dev/null 2>&1 || { print -u2 "wt: necesita zoxide"; return 1; }

  # pick repo: zoxide dirs that are git roots
  local repo
  repo=$(
    zoxide query -l 2>/dev/null | while IFS= read -r d; do
      [[ -d "$d/.git" ]] && print -r -- "$d"
    done | fzf --reverse --height=100% --prompt='repo > ' --header='elige repo (zoxide)'
  )
  [[ -z "$repo" ]] && return 0

  # pick an existing branch (local+remote) or type a new one. The synthetic top row
  # "＋ crear «…»" is regenerated live via change:reload; --print-query returns the typed text.
  local branches out
  branches=$(
    {
      git -C "$repo" for-each-ref --format='%(refname:short)'    refs/heads
      git -C "$repo" for-each-ref --format='%(refname:lstrip=3)' refs/remotes | grep -vx HEAD
    } | awk 'NF && !seen[$0]++'
  )
  out=$(
    print -r -- "$branches" \
      | fzf --print-query --reverse --height=100% --prompt='rama > ' \
            --header="repo: ${repo:t} · elige una rama o teclea una nueva para crearla" \
            --bind "change:reload:{ [ -n {q} ] && printf '＋ crear «%s»\n' {q}; { git -C ${(q)repo} for-each-ref --format='%(refname:short)' refs/heads; git -C ${(q)repo} for-each-ref --format='%(refname:lstrip=3)' refs/remotes | grep -vx HEAD; } | awk 'NF && !seen[\$0]++'; }"
  )
  # --print-query output: line 1 = query, line 2 = selection
  local -a lines; lines=("${(@f)out}")
  local query="${lines[1]:-}" pick="${lines[2]:-}" branch mode
  if [[ -n "$pick" ]] && print -r -- "$branches" | grep -qxF -- "$pick"; then
    branch="$pick";  mode="existente"
  else
    branch="$query"; mode="nueva"
  fi
  [[ -z "$branch" ]] && return 0

  local repo_name worktree_dir
  repo_name=${repo:t}
  worktree_dir="${repo:h}/${repo_name}-worktrees/${branch}"

  if [[ -d "$worktree_dir" ]]; then
    print -r -- "wt: el worktree ya existe -> $worktree_dir"
  elif [[ "$mode" == "existente" ]]; then
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
    print -r -- "wt: rama nueva '${branch}' desde '${base}'"
    mkdir -p "${worktree_dir:h}"
    git -C "$repo" worktree add --no-track -b "$branch" "$worktree_dir" "$base" || return 1
  fi

  print -r -- "wt: worktree en $worktree_dir  (rama ${branch}, modo ${mode})"

  # copy .env* into the worktree if present (never overwrite)
  local f
  for f in .env .env.local; do
    [[ -f "$repo/$f" && ! -f "$worktree_dir/$f" ]] && cp "$repo/$f" "$worktree_dir/$f"
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
    print -u2 "wt-rm: no estás dentro de un repo git"; return 1
  }
  main_root=$(git worktree list --porcelain | sed -n '1s/^worktree //p')
  if [[ "$worktree_dir" == "$main_root" ]]; then
    print -u2 "wt-rm: estás en el worktree principal, no en una tarea"; return 1
  fi
  repo_name=${main_root:t}
  branch=$(git rev-parse --abbrev-ref HEAD)
  session="${repo_name}/${branch}"       # same name wt used (full branch, may contain '/')
  session=${session//[.:]/-}

  # guard: without -f, require the branch's PR to be MERGED
  if [[ -z "$force" ]]; then
    state=$(gh pr view "$branch" --json state -q .state 2>/dev/null)
    if [[ "$state" != "MERGED" ]]; then
      print -u2 "wt-rm: el PR de '$branch' no está MERGED (estado: ${state:-sin PR}); usa 'wt-rm -f' para forzar"
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

  # land on the repo's base session, then kill the task's
  # (relies on tmux `detach-on-destroy off`, so killing it doesn't detach you)
  if [[ -n "${TMUX:-}" ]]; then
    tmux has-session -t "=$repo_name" 2>/dev/null || tmux new-session -d -s "$repo_name" -c "$main_root"
    tmux switch-client -t "$repo_name"
  fi
  tmux kill-session -t "=$session" 2>/dev/null

  print -r -- "wt-rm: cerrada '$branch' (worktree, rama y sesión eliminados)"
}
