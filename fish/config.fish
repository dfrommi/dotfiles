set -g -x fish_greeting ''

# see https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish
#set -x __fish_git_prompt_show_informative_status 'yes'
#set -x __fish_git_prompt_showcolorhints 'yes'
#set -x __fish_git_prompt_char_cleanstate '🍺 '
#set -x ___fish_git_prompt_char_cleanstate '👍 '
#set -x ___fish_git_prompt_char_dirtystate '⚡️ '
set -x DEFAULT_USER dennis

set -x GROOVY_HOME '/usr/local/opt/groovy/libexec'
set -x JAVA_HOME (/usr/libexec/java_home)

set -x PATH ~/my/bin /Applications/Docker.app/Contents/Resources/bin $HOME/.sdkman/candidates/*/current/bin $PATH

set -x FZF_LEGACY_KEYBINDINGS 0
set -x FZF_FIND_FILE_COMMAND "ag -l -g '' --ignore .git --ignore Library"

set -x EDITOR micro
set -x MICRO_TRUECOLOR 1

abbr brwe brew
abbr cask brew cask

abbr g git
abbr gcm git commit -m
abbr gca git commit --amend --no-edit

alias e micro
alias cat ccat

# Keep Fisherman out of regular fish config, otherwise all symlinks have to be added to gitignore
# fisher tool assets, like fisher completion
set -g fish_config $HOME/.config/fisherman
# symbolic links to functions etc.
set -g fish_path $HOME/.config/fisherman
# installed packages
set -g fisher_config $HOME/.config/fisherman
set -g fisher_file $HOME/.config/fish/fishfile

set fish_function_path $fish_config/functions $fish_function_path
set fish_complete_path $fish_config/completions $fish_complete_path
# install missing packages
fisher -q

# Fisherman conf.d is not detected
for file in $fish_config/conf.d/*.fish
  source $file
end

test -e ~/.config/fish/config.local.fish ; and source ~/.config/fish/config.local.fish
test -e ~/.config/fish/functions/iterm2_print_user_vars.fish ; and source ~/.config/fish/functions/iterm2_print_user_vars.fish
