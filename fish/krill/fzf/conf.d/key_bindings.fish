function __fzf_kb_insert
    set -l result $argv
    if test (count $result) -gt 0
        commandline -i (string escape -- $result | string join ' ')
    end
    commandline -f repaint
end

function __fzf_kb_insert_path
    set -l result $argv
    if test (count $result) -gt 0
        commandline -i ' '(string escape -- $result | string join ' ')
    end
    commandline -f repaint
end

bind -M default ' f' '__fzf_kb_insert_path (fzf_file_cwd)'
bind -M default ' F' '__fzf_kb_insert_path (fzf_file_git_root)'
bind -M default ' d' '__fzf_kb_insert_path (fzf_directory_cwd)'
bind -M default ' D' '__fzf_kb_insert_path (fzf_directory_git_root)'
bind -M default ' h' '__fzf_kb_insert (fzf_history)'
bind -M default 'gr' 'cd_git_root; commandline -f repaint'
bind -M default 'gz' 'zi; commandline -f repaint'
#bind -M default ' z' 'fzf_zoxide; commandline -f repaint'
