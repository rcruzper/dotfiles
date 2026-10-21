export EDITOR='nvim'
export KUBE_EDITOR='nvim'

export HOMEBREW_NO_ANALYTICS=true
export HOMEBREW_CURL_RETRIES=1

# Rose Pine Moon palette, same as nvim, tmux and bat: https://github.com/rose-pine/fzf
export FZF_DEFAULT_OPTS="--height 60% \
--color=fg:#908caa,bg:#232136,hl:#ea9a97 \
--color=fg+:#e0def4,bg+:#393552,hl+:#ea9a97 \
--color=border:#44415a,header:#3e8fb0,gutter:#232136 \
--color=spinner:#f6c177,info:#9ccfd8 \
--color=pointer:#c4a7e7,marker:#eb6f92,prompt:#908caa"

export DOTFILES_PATH="$HOME/.dotfiles"

export BAT_THEME="rose-pine"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=30000
export SAVEHIST=30000

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="git --no-pager diff --name-only; git ls-files --others --exclude-standard"

# The Homebrew prefix is fixed on Apple silicon. Do not use `brew --prefix`
# here: each call costs ~20 ms at every shell start.

# Configure completions: https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null
then
    FPATH="/opt/homebrew/share/zsh/site-functions:${FPATH}"
fi

export PATH=/opt/homebrew/opt/rustup/bin:/opt/homebrew/bin:~/.bun/bin:$PATH
