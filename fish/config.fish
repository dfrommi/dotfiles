set -g -x fish_greeting ''

# see https://github.com/fish-shell/fish-shell/blob/master/share/functions/__fish_git_prompt.fish
#set -x __fish_git_prompt_show_informative_status 'yes'
#set -x __fish_git_prompt_showcolorhints 'yes'
#set -x __fish_git_prompt_char_cleanstate '🍺 '
#set -x ___fish_git_prompt_char_cleanstate '👍 '
#set -x ___fish_git_prompt_char_dirtystate '⚡️ '

set -x GRAILS_OPTS '-Dfile.encoding=UTF8 -Xmx4096m -Xms256m -XX:PermSize=256M -XX:MaxPermSize=4096M -Xdebug -Xnoagent  -Dgrails.full.stacktrace=true -Djava.compiler=NONE -Xrunjdwp:transport=dt_socket,server=y,suspend=n,address=5006'

set -x GROOVY_HOME '/usr/local/opt/groovy/libexec'
set -x JAVA_HOME (/usr/libexec/java_home -v 1.7)

set -x GRADLE_HOME /usr/local/Cellar/gradle/2.8/libexec

set -x PATH $PATH $HOME/tado/bin /Library/TeX/texbin $HOME/Applications/bin $HOME/Coding/Scripts

alias g git
alias mysql-docker "mysql -u root -h (docker-machine ip default)"
rvm default

test -e ~/.config/fish/config.local.fish ; and source ~/.config/fish/config.local.fish
test -e ~/.config/fish/iterm2_shell_integration.fish ; and source ~/.config/fish/iterm2_shell_integration.fish
source ~/.config/fish/functions/iterm2_print_user_vars.fish
