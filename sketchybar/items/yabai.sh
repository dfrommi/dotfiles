#!/bin/bash

yabai=(
	icon.width=0
	label.width=0
	script="$PLUGIN_DIR/yabai.sh"
	icon.font="$FONT:Bold:16.0"
	display=active
	padding_right=10
	icon.background.color=$TRANSPARENT
	background.color=$TRANSPARENT
	background.border_width=0
)

sketchybar --add event window_focus \
	--add item yabai right \
	--set yabai "${yabai[@]}" \
	--subscribe yabai window_focus
