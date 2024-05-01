#!/bin/bash

source "$CONFIG_DIR/colors.sh"
COLOR=$BACKGROUND_2
if [ "$SELECTED" = "true" ]; then
	COLOR=$BLUE
fi
sketchybar --set $NAME icon.highlight=$SELECTED \
	label.highlight=$SELECTED
#	background.border_color=$COLOR
