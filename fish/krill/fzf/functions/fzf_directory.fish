function fzf_directory
    set -x fzf_fd_opts -t d
    _fzf_search_directory $argv
    set -e fzf_fd_opts
end
