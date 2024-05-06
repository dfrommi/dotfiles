set -g -x fish_greeting ''

set -x DEFAULT_USER dennis

set -x PATH ~/my/bin ~/thirdparty/bin $PATH

set -x FZF_LEGACY_KEYBINDINGS 0
set -x FZF_FIND_FILE_COMMAND "ag -l -g '' --ignore .git --ignore Library"

set -x BAT_THEME Coldark-Dark

set -x GIT_REPOS_BASE_PATHS $HOME/{my,thirdparty} $HOME
