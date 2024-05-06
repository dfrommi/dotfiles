function fish_title
    # Disable all setting in iTerm under "Appearence -> Window & Tab titles"

    # $_ = command
    # $argv = commandline
    # $PWD = directory

    set base /
    set dir "$PWD"
    set cmd "$_"

    if [ "$GIT_ROOT" ]
        set base (basename "$GIT_ROOT")
        set dir (string replace "$GIT_ROOT" "" "$dir")
    else if string match -q -- "$HOME*" "$dir"
        set base "~"
        set dir (string replace "$HOME" "" "$dir")
    end

    if string match -q -- "/*" "$dir"
        set dir (string sub -s 2 "$dir")
    end

    echo -n "$base • "

    if [ "$dir" ]
        prompt_pwd "$dir"
    else
        echo -n "."
    end

    if [ "$cmd" != fish ]
        echo -n " [$cmd]"
    end
end
