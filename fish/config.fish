if test -e "/usr/local/bin/brew"
  eval (/usr/local/bin/brew shellenv)
else
  eval (/opt/homebrew/bin/brew shellenv)
end

if status is-interactive
  starship init fish | source
end
