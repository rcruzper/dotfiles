$LOAD_PATH.unshift File.dirname(__FILE__) + '/tools'
require 'logging'
require 'command'

module Vim
  module_function
  
  def update
    Log.info 'Updating vim plugins'
    Command.execute "vim +PlugUpgrade +PlugUpdate +PlugInstall +qall"
    Log.success 'Updating vim plugins'
  end

end
