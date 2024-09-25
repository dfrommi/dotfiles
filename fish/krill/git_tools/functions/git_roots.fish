function git_roots -d 'find all git repositories'
    set dirs $HOME
    if set -q GIT_REPOS_BASE_PATHS
        set dirs $GIT_REPOS_BASE_PATHS
    end

    fd -d 2 -t d -H -a -g .git $dirs | sed -e "s#$HOME/\(.*\)/\.git/#\1#"
end
