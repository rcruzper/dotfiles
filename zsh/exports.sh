export EDITOR='nvim'
export KUBE_EDITOR='nvim'

export HOMEBREW_NO_ANALYTICS=true

export FZF_DEFAULT_OPTS="--height 60% --color bg+:240"

export DOTFILES_PATH="$HOME/.dotfiles"

export BAT_THEME="Dracula"

export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=30000
export SAVEHIST=30000

export FZF_DEFAULT_COMMAND='fd --type f'
export FZF_CTRL_T_COMMAND="git --no-pager diff --name-only; git ls-files --others --exclude-standard"

# Configure completions: https://docs.brew.sh/Shell-Completion#configuring-completions-in-zsh
if type brew &>/dev/null
then
    FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi

export PATH=$PATH:/opt/homebrew/opt/kafka/bin
