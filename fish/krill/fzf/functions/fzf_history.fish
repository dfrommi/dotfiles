function fzf_history
    history | fzf-tmux --ansi --no-sort --header="History" | read cmd
    echo $cmd
end
