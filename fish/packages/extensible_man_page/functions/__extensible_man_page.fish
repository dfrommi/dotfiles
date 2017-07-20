function __extensible_man_page
  set -l args (commandline -po | string match -rv '^-')

  if begin; functions -q __my_man_page; and [ "$args[1]" ]; end
    set args[1] (basename $args[1])
    if __my_man_page $args
      return 0
    end
  end

  __fish_man_page
end
