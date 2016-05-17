require_relative 'tools/logging'
require_relative 'tools/utils'

def atom_setup(currentDir)
    info 'Installing atom packages'
    execute "apm install --packages-file #{currentDir}/atom/package-list.txt"
    execute 'apm upgrade'
    success 'Installing atom packages'
end