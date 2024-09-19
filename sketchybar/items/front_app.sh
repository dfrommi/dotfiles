#!/bin/bash

front_app=(
  display=active
  icon.font="sketchybar-app-font:Regular:20.0"
  #icon.background.drawing=off
  icon.color=$GREY
  background.color=$BAR_COLOR
  icon.background.color=$BAR_COLOR
  icon.padding_right=5
  label.padding_left=5
  label.font="$FONT:Medium:14.0"
  label.color=$GREY
  background.border_width=0
  script="$PLUGIN_DIR/front_app.sh"
)

sketchybar --add item front_app left \
  --add event front_app_name_changed \
  --set front_app "${front_app[@]}" \
  --subscribe front_app front_app_switched \
  --subscribe front_app front_app_name_changed
