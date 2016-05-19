require 'rake'
require_relative 'install/tools/logging'
require_relative 'install/brew'
require_relative 'install/git'
require_relative 'install/zsh'
require_relative 'install/symlink'
require_relative 'install/zgen'
require_relative 'install/atom'
require_relative 'install/osx'

task :default => :install

desc 'Install dotfiles'
task :install do
    currentDir = File.dirname(__FILE__)
    `cd #{currentDir}`

    osx_setup
    symlink_install
    git_config(currentDir)
    brew_install
    zsh_setup
    zgen_setup
    atom_setup(currentDir)
end

desc 'Update repository'
task :update do
    currentDir = File.dirname(__FILE__)
    `cd #{currentDir}`

    info 'Updating dotfiles'
    execute('git pull')
    execute('git submodule update --init --recursive')
    success 'Updating dotfiles'
end
