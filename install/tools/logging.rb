module Tty
  module_function

  def blue; bold 34; end
  def white; bold 39; end
  def yellow; bold 33; end
  def green; bold 32; end
  def red; underline 31; end
  def reset; escape 0; end
  def bold n; escape "1;#{n}" end
  def underline n; escape "4;#{n}" end
  def escape n; "\033[#{n}m" if STDOUT.tty? end
end

class Array
  def shell_s
    cp = dup
    first = cp.shift
    cp.map{ |arg| arg.gsub " ", "\\ " }.unshift(first) * " "
  end
end

module Log
  module_function

  def info *args
    puts "[ #{Tty.blue}..#{Tty.white} ] #{args.shell_s}#{Tty.reset}"
  end

  def user *args
    print "[ #{Tty.yellow}??#{Tty.white} ] #{args.shell_s}#{Tty.reset}"
  end

  def success *args
    puts "[ #{Tty.green}OK#{Tty.white} ] #{args.shell_s}#{Tty.reset}"
  end

  def fail *args
    abort "[ #{Tty.red}KO#{Tty.white} ] #{args.shell_s}#{Tty.reset}"
  end
end
