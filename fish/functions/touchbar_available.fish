function touchbar_available -d "Check if touchbar can be used (interactive and shell supports it)"
    status is-interactive; and set -q ITERM_SESSION_ID
end