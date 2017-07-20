function gh_repo -d 'get github repo name'
  git config --get remote.origin.url | sed 's/git@github.com:\(.*\).git/\1/'
end
