#!/bin/bash

source "$CONFIG_DIR/icons.sh"

wifi=(
	label.width=0
	padding_left=0
	icon.background.color=$BLACK
	background.border_width=0
	icon="$WIFI_DISCONNECTED"
	script="$PLUGIN_DIR/wifi.sh"
)

sketchybar --add item wifi right \
	--set wifi "${wifi[@]}" \
	--subscribe wifi wifi_change mouse.clicked
