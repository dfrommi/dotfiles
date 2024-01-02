if test -e "/usr/local/bin/brew"
  eval (/usr/local/bin/brew shellenv)
else
  eval (/opt/homebrew/bin/brew shellenv)
end

if status is-interactive
  starship init fish | source
end

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
if test -f /opt/homebrew/Caskroom/miniconda/base/bin/conda
    eval /opt/homebrew/Caskroom/miniconda/base/bin/conda "shell.fish" "hook" $argv | source
end
# <<< conda initialize <<<

