require_relative 'tools/logging'
require_relative 'tools/utils'

def symlink_install
    info 'Installing symlinks'
    skip_all = false
    overwrite_all = false
    backup_all = false

    Dir['**/*.symlink'].each do |symlink|
        overwrite = false
        backup = false

        file = symlink.split('/').last.split('.symlink').last
        target = "#{ENV["HOME"]}/.#{file}"

        if File.exists?(target) || File.symlink?(target)
            unless skip_all || overwrite_all || backup_all
                user "File already exists: #{target}, what do you want to do? [s]kip, [S]kip all, [o]verwrite, [O]verwrite all, [b]ackup, [B]ackup all? "
                case STDIN.gets.chomp
                    when 'o' then overwrite = true
                    when 'b' then backup = true
                    when 'O' then overwrite_all = true
                    when 'B' then backup_all = true
                    when 'S' then skip_all = true
                    when 's' then next
                end
            end
            FileUtils.rm_rf(target) if overwrite || overwrite_all
            `mv "$HOME/.#{file}" "$HOME/.#{file}.backup"` if backup || backup_all
        end
        `ln -s "$PWD/#{symlink}" "#{target}"` unless skip_all
    end
    success 'Installing symlinks'
end
