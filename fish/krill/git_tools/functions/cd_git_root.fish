function cd_git_root
  if set -q GIT_ROOT
  	cd "$GIT_ROOT"
  end
end
