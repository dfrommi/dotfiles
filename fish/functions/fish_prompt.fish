function fish_prompt
    set -l last_pipestatus $pipestatus
    set -lx __fish_last_status $status # Export for __fish_print_pipestatus.

    set -l cwd (pwd | string replace "$HOME" '~')

    # "clear to bottom of screen"
    # Workaround for https://github.com/fish-shell/fish-shell/issues/5860
    printf '\033[J'

    echo ''

    set_color green
    echo -s $cwd
    set_color normal

    set -l prompt_symbol_color normal

    for status_code in $last_pipestatus
        if test "$status_code" -ne 0
            set prompt_symbol_color red
            break
        end
    end

    set_color "$prompt_symbol_color"
    echo -n "❯ "
    set_color normal
end
