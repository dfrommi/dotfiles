function iterm2_print_user_vars
  set GIT_BRANCH (git branch 2> /dev/null | grep \* | cut -c3-)
  if [ $GIT_BRANCH ]
    iterm2_set_user_var gitBranch $GIT_BRANCH
  end
  
  iterm2_set_user_var pwd (echo $PWD | sed "s#^$HOME#~#")
end
