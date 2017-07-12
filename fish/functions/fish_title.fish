function fish_title
	# Disable all setting in iTerm under "Appearence -> Window & Tab titles"

	# $_ = command
	# $argv = commandline
	# $PWD = directory

  if [ "$PWD" = "$HOME" ]
    echo "~"
    return 0
  end

  set dir "$PWD"

  if [ "$GIT_ROOT" ]
    set dir (string replace (dirname "$GIT_ROOT")/ "" "$dir")
  else
    set dir (string replace "$HOME" "~" "$dir")
  end

  if [ (basename "$PWD") = "$dir" ]
    echo (basename "$PWD")
  else
    echo (basename "$PWD") '•' (dirname "$dir")
  end
end
