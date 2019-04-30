# pyenv
status --is-interactive; and source (pyenv init -|psub)

# see https://github.com/pyenv/pyenv/issues/530
alias pyenv "env CFLAGS=-I(xcrun --show-sdk-path)/usr/include pyenv"

# pipenv
set -x VIRTUAL_ENV_DISABLE_PROMPT 1
set -x PIPENV_SHELL_FANCY 1

eval (pipenv --completion)
