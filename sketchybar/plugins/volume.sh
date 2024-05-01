#!/bin/bash

source "$CONFIG_DIR/icons.sh"

case $INFO in
[6-9][0-9] | 100)
	ICON=$VOLUME_100
	DRAWING=on
	;;
[3-5][0-9])
	ICON=$VOLUME_66
	DRAWING=on
	;;
[1-2][0-9])
	ICON=$VOLUME_33
	DRAWING=off
	;;
[1-9])
	ICON=$VOLUME_10
	DRAWING=on
	;;
0)
	ICON=$VOLUME_0
	DRAWING=on
	;;
*)
	ICON=$VOLUME_100
	DRAWING=on
	;;
esac

echo "VOLUME = $INFO / $ICON"
sketchybar --set volume_icon drawing=$DRAWING icon=$ICON
echo sketchybar --set volume_icon drawing=$DRAWING icon=$ICON
