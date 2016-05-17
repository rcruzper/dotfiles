require_relative 'tools/logging'
require_relative 'tools/utils'

def zgen_setup
    if ENV['SHELL'] == "/usr/local/bin/zsh" then
        info 'Updating zgen'
        execute 'zsh -c "source ~/.zshrc && zgen update && source ~/.zshrc"'
        success 'Updating zgen'
    end
end