#!/bin/bash

echo "EVENT $SENDER $INFO"

if [[ "$SENDER" = "front_app_switched" || "$SENDER" = "front_app_name_changed" ]]; then
  ICON=$($CONFIG_DIR/plugins/icon_map.sh "$INFO")

  if [ "$INFO" = "kitty" ]; then
    INFO=$(tmux list-sessions -F "#{session_name}" -f "#{session_attached}")
  fi

  # Set the app name and app icon and then animate a bounce for the icon size
  #sketchybar --set $NAME label="$INFO" icon.background.image="app.$INFO" \
  sketchybar --set $NAME label="$INFO" icon="$ICON" \
    --animate tanh 10 --set $NAME icon.background.image.scale=1.2 \
    icon.background.image.scale=1
fi
