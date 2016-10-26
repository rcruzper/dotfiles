$LOAD_PATH.unshift File.dirname(__FILE__) + '/tools'
require 'logging'
require 'command'

module Zgen
  module_function

  def update
    if ENV['SHELL'] == '/usr/local/bin/zsh' then
      Log.info 'Updating zgen'
      Command.execute 'zsh -c "source ~/.zshrc && zgen reset && zgen update && source ~/.zshrc"'
      Log.success 'Updating zgen'
    end
  end

end
