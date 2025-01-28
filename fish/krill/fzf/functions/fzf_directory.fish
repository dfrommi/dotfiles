function fzf_directory -a base_path
    fd --base-directory="$base_path" -t d --color=always |
        fzf-tmux --multi --ansi --prompt="Directory >" --preview="ls -1 --color=always '$base_path/{}'"
end
