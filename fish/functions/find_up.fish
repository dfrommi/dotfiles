function find_up -a file -d 'find in current and parent directories'
  [ "$file" ]; or return 1

  set -l dir $PWD
  while [ "$dir" ]
    set -l current_file "$dir/$file"
    if [ -e "$current_file" ]
      echo -n "$current_file"
      return 0
    end

    set dir (string replace -r '(.*)/.*' '$1' "$dir")
  end

  return 1
end
