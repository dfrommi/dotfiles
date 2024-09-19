#!/bin/bash

echo "EVENT $SENDER"

if [[ "$SENDER" = "front_app_switched" || "$SENDER" = "windows_changed" ]]; then
  if [[ "$INFO" = "kitty" || "$INFO" = "tmux" ]]; then
    echo "Setting windows - $INFO"
    #TODO support multiple instances
    #/Applications/kitty.app/Contents/MacOS/kitten @ --to unix:$(ls -1 /tmp/.kitty-* | head -1) ls | jq -r -f $CONFIG_DIR/kittytabs.jq | xargs sketchybar
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
