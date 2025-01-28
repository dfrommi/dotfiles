function fzf_directory_git_root
    if [ -z "$GIT_ROOT" ]
        return 1
    end

    fzf_directory "$GIT_ROOT"
end
