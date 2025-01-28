function fzf_file_git_root
    if [ -z "$GIT_ROOT" ]
        return 1
    end

    fzf_file "$GIT_ROOT"
end
