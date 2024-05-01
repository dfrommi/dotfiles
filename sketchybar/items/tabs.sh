#!/bin/bash

for tid in $(seq -s " " 9 1); do
	tab=(
		drawing=off
		icon=$tid
		label.padding_left=20
		label.padding_right=20
	)

	sketchybar --add item tab.$tid q \
		--set tab.$tid "${tab[@]}"
done

sketchybar \
	--add event tabs_changed \
	--set tab.1 script="$PLUGIN_DIR/tabs.sh" updates='on' \
	--subscribe tab.1 front_app_switched \
	--subscribe tab.1 tabs_changed
