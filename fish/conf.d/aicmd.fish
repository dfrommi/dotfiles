function _aicmd_fish
    set -l _old (commandline)
    if test -n $_old
        echo -n "⌛"
        commandline -f repaint
        commandline (hunch $_old)
    end
end

bind ' aa' _aicmd_fish
