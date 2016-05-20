require_relative 'tools/logging'
require_relative 'tools/utils'

def brew_install
    if osx? then
        unless which('brew') then
            info 'Installing brew'
            execute('ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
            success 'Installing brew'
        else
            fixPermissions

            info 'Updating brew'
            execute 'brew update'
            success 'Updating brew'

            info 'Upgrading brew formulaes'
            execute('brew upgrade')
            success 'Upgrading brew formulaes'

            linkUnlinkedFormulaes

            info 'Cleaning up old formulaes'
            execute 'brew cleanup'
            execute 'brew cask cleanup'
            success 'Cleaning up old formulaes'

            info 'Installing homebrew packages'
            Dir.chdir('brew')
            execute 'brew bundle'
            Dir.chdir('..')
            success 'Installing homebrew packages'
        end
    end
end

def fixPermissions
    files = `find /usr/local -user $(whoami) | wc -l`
    userFiles = `find /usr/local | wc -l`
    if files != userFiles then
        info 'Fixing brew permissions'
        execute 'sudo chown -R "$USER":admin /usr/local'
        success 'Fixing brew permissions'
    end
end

def linkUnlinkedFormulaes
    #execute('brew list -1 | while read line; do brew unlink $line; brew link --overwrite --force $line; done')
    execute 'brew doctor &> brew_doctor.txt'
    File.readlines('brew_doctor.txt', "\n\n").map{ |s| s.rstrip.split("\n") }.each do |paragraph|
        if paragraph.include? 'Warning: You have unlinked kegs in your Cellar'
            info 'Relinking unlinked formulaes'
            paragraph.each do |line|
                if line.include? '    '
                    execute 'brew link --overwrite --force ' + line.lstrip
                end
            end
            success 'Relinking unlinked formulaes'
            break
        end
    end
    execute 'rm brew_doctor.txt'
end
