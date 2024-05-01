#!/bin/bash

if [ "$SENDER" = "front_app_switched" ]; then
	ICON=$($CONFIG_DIR/plugins/icon_map.sh "$INFO")

	# Set the app name and app icon and then animate a bounce for the icon size
	#sketchybar --set $NAME label="$INFO" icon.background.image="app.$INFO" \
	sketchybar --set $NAME label="$INFO" icon="$ICON" \
		--animate tanh 10 --set $NAME icon.background.image.scale=1.2 \
		icon.background.image.scale=1
fi
