function gh_pr -d 'create pull request'
  set -l branch (git_branch_name)
  set -l repo (gh_repo)

  if [ "$repo" -a "$branch" != "master" ]
    open "https://github.com/$repo/compare/$branch?expand=1"
  end
end
