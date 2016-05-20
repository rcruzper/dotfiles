$LOAD_PATH.unshift File.dirname(__FILE__) + '/tools'
require 'logging'

module Git
  module_function

  def config dotfiles_home
    unless File.exists?(dotfiles_home + '/git/gitconfig.local.symlink') then
      Log.info 'Setting up gitconfig'

      Log.user ' - What is your git author name? '
      git_author_name = STDIN.gets.chomp
      Log.user ' - What is your git author email? '
      git_author_email = STDIN.gets.chomp

      gitconfig_example_file = File.read('git/gitconfig.local.symlink.example')
      gitconfig_file = File.new('git/gitconfig.local.symlink', 'w')
      gitconfig_file.puts(gitconfig_example_file.gsub(/AUTHORNAME/, git_author_name).gsub(/AUTHOREMAIL/, git_author_email))

      Log.success 'Setting up gitconfig'
    end
  end

end
