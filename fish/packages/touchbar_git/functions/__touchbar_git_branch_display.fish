function __touchbar_git_branch_display --on-variable GIT_BRANCH
  if [ "$GIT_BRANCH" ]
    echo -ne "\033]1337;SetKeyLabel=F4=⌥ $GIT_BRANCH\a"
  else
    echo -ne "\033]1337;SetKeyLabel=F4=F4\a"
  end
end
