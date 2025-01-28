function fzf_file -a base_path
    fd --base-directory="$base_path" -t f --color=always |
        fzf-tmux --multi --ansi --prompt="File >" --preview="bat -f '$base_path/{}'"
end

