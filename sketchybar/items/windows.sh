#!/bin/bash

for tid in $(seq -s " " 1 9); do
	item=(
		drawing=off
		icon=$tid
		label.padding_left=15
		label.padding_right=15
		icon.font.style=medium
		icon.drawing=off
		background.color=$BACKGROUND_2
	)

	sketchybar --add item window.$tid e \
		--set window.$tid "${item[@]}"
done

sketchybar \
	--add event windows_changed \
	--set window.1 script="$PLUGIN_DIR/windows.sh" updates='on' \
	--subscribe window.1 front_app_switched \
	--subscribe window.1 windows_changed
