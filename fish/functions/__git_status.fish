function __git_status --on-event fish_prompt --on-variable PWD
  set branch_name (git_branch_name)
  if [ "$branch_name" != "$GIT_BRANCH" ]
    set -g GIT_BRANCH "$branch_name"
  end

  set git_root (git_repository_root)
  if [ "$git_root" != "$GIT_ROOT" ]
    set -g GIT_ROOT "$git_root"
  end
end
