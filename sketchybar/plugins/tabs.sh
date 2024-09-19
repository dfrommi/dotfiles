#!/bin/bash

echo "EVENT $SENDER"

if [[ "$SENDER" = "front_app_switched" || "$SENDER" = "tabs_changed" ]]; then
  if [[ "$INFO" = "kitty" || "$INFO" = "tmux" ]]; then
    echo "Setting tabs - $INFO"
    #TODO support multiple instances
    #/Applications/kitty.app/Contents/MacOS/kitten @ --to unix:$(ls -1 /tmp/.kitty-* | head -1) ls | jq -r -f $CONFIG_DIR/kittytabs.jq | xargs sketchybar
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
