#!/bin/bash

calendar=(
	icon=cal
	icon.font="$FONT:Black:12.0"
	update_freq=30
	padding_left=15
	script="$PLUGIN_DIR/calendar.sh"
)

sketchybar --add item calendar right \
	--set calendar "${calendar[@]}" \
	--subscribe calendar system_woke
