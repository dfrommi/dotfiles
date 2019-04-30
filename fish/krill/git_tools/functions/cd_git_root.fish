function cd_git_root
  if set git_root (git_repository_root)
  	cd "$git_root"
    commandline -f repaint
  end
end
