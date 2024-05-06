#!/bin/bash

volume_icon=(
	icon=$VOLUME_100
	icon.width=30
	icon.align=left
	icon.color=$GREY
	icon.background.color=$TRANSPARENT
	icon.font="$FONT:Regular:14.0"
	background.color=$TRANSPARENT
	background.border_width=0
	label.width=0
	updates=on
	script="$PLUGIN_DIR/volume.sh"
)

status_bracket=(
	background.color=$BACKGROUND_1
	background.border_color=$BACKGROUND_2
)

sketchybar --add item volume_icon right \
	--set volume_icon "${volume_icon[@]}" \
	--subscribe volume_icon volume_change

#sketchybar --add bracket status battery volume_icon \
#  --set status "${status_bracket[@]}"
