$LOAD_PATH.unshift File.dirname(__FILE__) + '/install'
require 'rake'
require 'tools/logging'
require 'tools/command'
require 'brew'
require 'git'
require 'zsh'
require 'symlink'
require 'zgen'
require 'atom'
require 'osx'
require 'vim'

task :default => :install

desc 'Install dotfiles'
task :install do
  dotfiles_home = File.dirname(__FILE__)
  Dir.chdir dotfiles_home

  Osx.setup
  Git.config dotfiles_home
  Symlink.install
  Brew.install
  Zsh.setup
  Zgen.update
  Vim.update
  Atom.setup dotfiles_home
end

desc 'Update repository'
task :update do
  dotfiles_home = File.dirname(__FILE__)
  Dir.chdir dotfiles_home

  Log.info 'Updating dotfiles'
  Command.execute('git pull')
  Command.execute('git submodule update --init --recursive')
  Log.success 'Updating dotfiles'
end
