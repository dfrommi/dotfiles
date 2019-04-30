function __touchbar_git_root_display --on-variable GIT_ROOT
    set display_name "🤷🏻‍♂️"
    set -g TOUCHBAR_DIRECTORY "_UNKNOWN_"

    if [ "$GIT_ROOT" ]
      set -g TOUCHBAR_DIRECTORY $GIT_ROOT
      set display_name (basename $GIT_ROOT)
    end

    echo -ne "\033]1337;SetKeyLabel=F3=$display_name\a"
end
