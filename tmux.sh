#!/bin/zsh
set -eEuxo pipefail

# apt install tmux
# tmux new -As default

tmux() {
  if [ $# -eq 0 ]; then
    command tmux new -A -s default
  else
    command tmux "$@"
  fi
}

