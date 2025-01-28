# see https://junegunn.github.io/fzf/tips/ripgrep-integration/
function fzf_grep
    set -l RELOAD "reload:rg --column --color=always --smart-case {q} || :"
    set -l pattern (echo "$argv" | sed 's|^!/||')

    fzf-tmux --disabled --ansi --multi \
        --bind "start:$RELOAD" --bind "change:$RELOAD" \
        --bind 'alt-a:select-all,alt-d:deselect-all,ctrl-/:toggle-preview' \
        --delimiter : \
        --preview 'bat --style=full --color=always --highlight-line {2} {1}' \
        --preview-window '~4,+{2}+4/3,<80(up)' \
        --query "$pattern" | cut -d ':' -f 1 | sort -u | string join ' '

    if test $pipestatus[1] -ne 0
        return 1
    end
end
