# Install fisher if required
if not functions -q fisher
	brew tap fisherman/tap
	brew install fisherman
end

# Keep Fisherman out of regular fish config, otherwise all symlinks have to be added to gitignore
# fisher tool assets, like fisher completion
set -g fish_config $HOME/.fisherman
# symbolic links to functions etc.
set -g fish_path $HOME/.fisherman
# installed packages
set -g fisher_config $HOME/.fisherman
set -g fisher_file $HOME/.config/fish/fishfile

set fish_function_path $fish_config/functions $fish_function_path
set fish_complete_path $fish_config/completions $fish_complete_path

# install missing packages
fisher -q

# Fisherman conf.d is not detected
for file in $fish_config/conf.d/*.fish
  source $file
end
