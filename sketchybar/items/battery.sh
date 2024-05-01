#!/bin/bash

battery=(
	script="$PLUGIN_DIR/battery.sh"
	icon.font="$FONT:Regular:19.0"
	padding_right=0
	padding_left=0
	label.drawing=off
	update_freq=120
	updates=on
	background.color=$TRANSPARENT
	icon.background.color=$TRANSPARENT
	background.border_width=0
)

sketchybar --add item battery right \
	--set battery "${battery[@]}" \
	--subscribe battery power_source_change system_woke
