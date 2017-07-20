function gh_repo -d 'get github repo name'
  set -l url (git config --get remote.origin.url); or return 1
  echo -ne $url | sed 's/git@github.com:\(.*\).git/\1/'
end
