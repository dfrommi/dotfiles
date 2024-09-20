#!/bin/bash

echo "EVENT $SENDER"

if [[ "$SENDER" = "front_app_switched" || "$SENDER" = "tabs_changed" ]]; then
  if [[ "$INFO" = "WezTerm" || "$INFO" = "tmux" ]]; then
    $CONFIG_DIR/tmux_windows.sh
  else
    sketchybar \
      --set tab.1 drawing='off' \
      --set tab.2 drawing='off' \
      --set tab.3 drawing='off' \
      --set tab.4 drawing='off' \
      --set tab.5 drawing='off' \
      --set tab.6 drawing='off' \
      --set tab.7 drawing='off' \
      --set tab.8 drawing='off' \
      --set tab.9 drawing='off'
  fi
fi
