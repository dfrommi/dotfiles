function cdg -a dir -d 'cd into git repo'
  if [ -z "$dir" ]
    git_repos | fzf | read dir
  end

  if [ -n "$dir" ]
    cd $HOME/$dir
  end
end
