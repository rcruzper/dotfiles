$LOAD_PATH.unshift File.dirname(__FILE__) + '/tools'
require 'logging'
require 'command'

module Brew
  module_function

  def install
    if Command.osx? then
      unless Command.which('brew') then
        Log.info 'Installing brew'
        Command.execute 'ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"'
        Log.success 'Installing brew'
      else
        fix_permissions

        Log.info 'Updating brew'
        Command.execute 'brew update'
        Log.success 'Updating brew'

        Log.info 'Upgrading brew formulaes'
        Command.execute 'brew upgrade'
        Log.success 'Upgrading brew formulaes'

        link_unlinked_formulaes

        Log.info 'Cleaning up old formulaes'
        Command.execute 'brew cleanup'
        Command.execute 'brew cask cleanup'
        Log.success 'Cleaning up old formulaes'

        brew_bundle
      end
    end
  end

  def brew_bundle
    Dir.chdir 'brew'
    brew_bundle_check = `brew bundle check`
    if brew_bundle_check.chomp != 'The Brewfile\'s dependencies are satisfied.'
      Log.info 'Installing homebrew packages'
      Command.execute 'brew bundle'
      Log.success 'Installing homebrew packages'
    end
    Dir.chdir '..'
  end

  def fix_permissions
    files = `find /usr/local -user $(whoami) | wc -l`
    user_files = `find /usr/local | wc -l`

    if files != user_files then
      Log.info 'Fixing brew permissions'
      Command.execute 'sudo chown -R "$USER":admin /usr/local'
      Log.success 'Fixing brew permissions'
    end
  end

  def link_unlinked_formulaes
    #execute('brew list -1 | while read line; do brew unlink $line; brew link --overwrite --force $line; done')
    Command.execute 'brew doctor &> brew_doctor.log'
    File.readlines('brew_doctor.log', "\n\n").map{ |s| s.rstrip.split("\n") }.each do |paragraph|
      if paragraph.include? 'Warning: You have unlinked kegs in your Cellar'
        Log.info 'Relinking unlinked formulaes'
        paragraph.each do |line|
          if line.include? '    '
            Command.execute 'brew link --overwrite --force ' + line.lstrip
          end
        end
        Log.success 'Relinking unlinked formulaes'
        break
      end
    end
    Command.execute 'rm brew_doctor.log'
  end

end
