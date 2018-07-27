set -g -x fish_greeting ''

set -x DEFAULT_USER dennis

set -x GROOVY_HOME '/usr/local/opt/groovy/libexec'
set -x JAVA_HOME (/usr/libexec/java_home)

set -x PATH ~/my/bin ~/thirdparty/bin /Applications/Docker.app/Contents/Resources/bin $HOME/.sdkman/candidates/*/current/bin $PATH

set -x FZF_LEGACY_KEYBINDINGS 0
set -x FZF_FIND_FILE_COMMAND "ag -l -g '' --ignore .git --ignore Library"

set -x EDITOR micro
set -x MICRO_TRUECOLOR 1

set -x GIT_REPOS_BASE_PATHS $HOME/{my,thirdparty,thirdparty/openhab2/git,tado/repo} $HOME

nvm use --silent default
