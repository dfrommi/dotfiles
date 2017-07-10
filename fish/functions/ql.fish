function ql -a input
  set input
  if [ -z "$input" ]
    set input (fzf)
  end

  if [ "$input" ]
    command qlmanage -p $input >/dev/null ^&1
  end
end
