function __touchbar_git_root_callback
  find $HOME/{my,thirdparty,tado} -name .git -type d -prune ^/dev/null | sed -e "s#$HOME/\(.*\)/\.git#\1#" | fzf | read -l target; and begin
    cd $HOME/$target
    commandline -f repaint
  end
end
