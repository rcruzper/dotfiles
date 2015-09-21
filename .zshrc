# Load Antigen
source ~/antigen/antigen.zsh

antigen use oh-my-zsh

# Antigen Bundles
antigen bundle robbyrussell/oh-my-zsh lib/
antigen bundle robbyrussell/oh-my-zsh plugins/git
antigen bundle zsh-users/zsh-syntax-highlighting
antigen bundle rupa/z
antigen bundle brew
antigen bundle brew-cask
antigen bundle osx
antigen bundle command-not-found
antigen bundle mvn

antigen bundle ssh-agent

# Load the theme
antigen theme norm

antigen apply
