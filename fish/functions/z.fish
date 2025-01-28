function z --wraps=__zoxide_z
    set -l argc (builtin count $argv)
    if test $argc -eq 0
        __cd_git_root_or_home
    else
        __zoxide_z $argv
    end
end

function __cd_git_root_or_home
    # Start from the current directory
    set dir (pwd)

    # If the current directory is a Git root, move up one level
    if test -d $dir/.git
        set dir (dirname $dir)
    end

    # Traverse upwards to find the next Git root
    while not test -d $dir/.git
        set dir (dirname $dir)
        if test $dir = /
            # No Git root found, go to home dir
            cd ~
            return
        end
    end

    # Found the next Git root, so cd there
    cd $dir
end
