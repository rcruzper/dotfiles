$LOAD_PATH.unshift File.dirname(__FILE__) + '/tools'
require 'logging'
require 'command'

module Zsh
  module_function

  def setup
    if ENV['SHELL'] != "/usr/local/bin/zsh" then
      Log.info 'Setting up zsh as default shell'

      if File.foreach('/etc/shells').grep(/\/usr\/local\/bin\/zsh/).size == 0 then
        Command.execute 'echo "/usr/local/bin/zsh" | sudo tee -a /etc/shells'
      end

      Command.execute 'sudo chsh -s "/usr/local/bin/zsh" "$(whoami)"'

      Log.success 'Setting up zsh as default shell'
    end
  end

end
