#!/bin/bash

echo "EVENT $SENDER"

if [[ "$SENDER" = "front_app_switched" || "$SENDER" = "windows_changed" ]]; then
  if [[ "$INFO" = "WezTerm" || "$INFO" = "tmux" ]]; then
    $CONFIG_DIR/tmux_sessions.sh
  else
    sketchybar \
      --set window.1 drawing='off' \
      --set window.2 drawing='off' \
      --set window.3 drawing='off' \
      --set window.4 drawing='off' \
      --set window.5 drawing='off' \
      --set window.6 drawing='off' \
      --set window.7 drawing='off' \
      --set window.8 drawing='off' \
      --set window.9 drawing='off'
  fi
fi
