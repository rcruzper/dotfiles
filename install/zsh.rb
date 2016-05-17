require_relative 'tools/logging'
require_relative 'tools/utils'

def zsh_setup
    if ENV['SHELL'] != "/usr/local/bin/zsh" then
        info 'Setting up zsh as default shell'

        if File.foreach('/etc/shells').grep(/\/usr\/local\/bin\/zsh/).size == 0 then
            execute 'echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells'
        end

        execute 'sudo chsh -s "/usr/local/bin/zsh" "$(whoami)"'

        success 'Setting up zsh as default shell'
    end
end