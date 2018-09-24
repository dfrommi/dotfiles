function __touchbar_git_diff_display --on-variable GIT_ROOT
    set display_name "F5"

    if [ "$GIT_ROOT" ]
      set display_name "🧐"
    end

    echo -ne "\033]1337;SetKeyLabel=F5=$display_name\a"
end
