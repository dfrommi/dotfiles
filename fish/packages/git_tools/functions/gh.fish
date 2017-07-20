function gh -d 'open githib repo in browser'
  set -l repo (gh_repo)
  [ "$repo" ]; and open "https://github.com/$repo"; or return 1
end
