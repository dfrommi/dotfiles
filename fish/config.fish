export XDG_CONFIG_HOME="$HOME/.config"

eval (/opt/homebrew/bin/brew shellenv)

#add shims manually after homebrew to make sure they are at the front of the path
fish_add_path -m $HOME/.asdf/shims
fish_add_path -m $HOME/.local/share/nvim/mason/bin

if status is-interactive
    starship init fish | source
end

