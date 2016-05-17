require_relative 'tools/logging'
require_relative 'tools/utils'

def brew_install
    if osx? then
        unless which('brew') then
            info 'Installing brew'
            execute('ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"')
            success 'Installing brew'
        else
            info 'Updating brew'
            files = `find /usr/local -user $(whoami) | wc -l`
            userFiles = `find /usr/local | wc -l`
            if files != userFiles then
                execute 'sudo chown -R "$USER":admin /usr/local'
            end
            execute 'brew update'
            success 'Updating brew'

            info 'Upgrading brew formulaes'
            execute('brew upgrade')
            success 'Upgrading brew formulaes'

            info 'Relinking all formuales'
            execute('brew list -1 | while read line; do brew unlink $line; brew link --overwrite --force $line; done')
            success 'Relinking all formuales'

            info 'Cleaning up old formulaes'
            execute('brew cleanup')
            success 'Cleaning up old formulaes'

            info 'Installing homebrew packages'
            Dir.chdir('brew')
            execute 'brew bundle'
            Dir.chdir('..')
            success 'Installing homebrew packages'
        end

    end
end