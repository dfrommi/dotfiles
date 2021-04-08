function ql -a input
  if [ -z "$input" ]
    set input (fzf)
  end

  if [ "$input" ]
    command qlmanage -p $input &>/dev/null
  end
end
