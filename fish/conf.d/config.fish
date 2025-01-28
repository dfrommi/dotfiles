set -g -x fish_greeting ''

set -x DEFAULT_USER dennis
set -x EDITOR nvim

set -x GIT_REPOS_BASE_PATHS $HOME/{my,thirdparty} $HOME

fish_add_path $HOME/my/bin
fish_add_path $HOME/thirdparty/bin

abbr brwe brew

abbr g git
abbr gcm git commit -m
abbr gca git commit --amend --no-edit
abbr gcf git commit --fixup
alias lg lazygit

abbr gr gradle

alias cat bat

functions -e gh

alias ll="ls -l"
alias la="ls -la"

alias vi nvim
alias vim nvim
alias e nvim
