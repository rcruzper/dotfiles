$LOAD_PATH.unshift File.dirname(__FILE__) + '/tools'
require 'logging'
require 'command'

module Zplug
  module_function

  def install
    if ENV['SHELL'] == '/usr/local/bin/zsh' then
      zplug = `zplug 2>&1`
      unless zplug.include? "not found" then
        Log.info 'Installing zplug'
        Command.execute 'zsh -c "curl -sL --proto-redir -all,https https://raw.githubusercontent.com/zplug/installer/master/installer.zsh| zsh"'
        Log.success 'Installing zplug'
      end
    end
  end

end
