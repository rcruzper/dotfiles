$LOAD_PATH.unshift File.dirname(__FILE__) + '/tools'
require 'logging'
require 'command'

module Atom
  module_function

  def setup dotfilesHome
    Log.info 'Installing atom packages'
    Command.execute "apm install --packages-file #{dotfilesHome}/atom/package-list.txt"
    Command.execute 'apm upgrade'
    Log.success 'Installing atom packages'
  end

end
