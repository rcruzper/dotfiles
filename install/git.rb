require_relative 'tools/logging'
require_relative 'tools/utils'

def git_config(currentDir)
    unless File.exists?(currentDir + '/git/gitconfig.local.symlink') then
        info 'Setting up gitconfig'

        user ' - What is your github author name? '
        gitAuthorName = gets.chomp
        user ' - What is your github author email? '
        gitAuthorEmail = gets.chomp

        gitconfigExampleFile = File.read('git/gitconfig.local.symlink.example')
        gitconfigFile = File.new('git/gitconfig.local.symlink', 'w')
        gitconfigFile.puts(gitconfigExampleFile.gsub(/AUTHORNAME/, gitAuthorName).gsub(/AUTHOREMAIL/, gitAuthorEmail))

        success 'Setting up gitconfig'
    end
end