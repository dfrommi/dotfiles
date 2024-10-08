#!/bin/bash

for tid in $(seq -s " " 1 9); do
  tab=(
    drawing=off
    icon=$tid
    label.padding_left=15
    label.padding_right=15
    icon.font.style=medium
  )

  #sketchybar --add item tab.$tid q \
  sketchybar --add item tab.$tid left \
    --set tab.$tid "${tab[@]}"
done

sketchybar \
  --add event tabs_changed \
  --set tab.1 script="$PLUGIN_DIR/tabs.sh" updates='on' \
  --subscribe tab.1 front_app_switched \
  --subscribe tab.1 tabs_changed
