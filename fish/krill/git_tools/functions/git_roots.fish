function git_roots -d 'find all git repositories'
  set dirs $HOME
  if set -q GIT_REPOS_BASE_PATHS
    set dirs $GIT_REPOS_BASE_PATHS
  end

  find $dirs -name .git -type d -maxdepth 2 -prune ^/dev/null | sed -e "s#$HOME/\(.*\)/\.git#\1#"
end
