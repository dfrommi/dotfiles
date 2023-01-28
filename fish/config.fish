eval (/opt/homebrew/bin/brew shellenv)

if status is-interactive
  starship init fish | source
end
