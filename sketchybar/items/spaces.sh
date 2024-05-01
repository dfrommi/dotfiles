#!/bin/bash

SPACE_ICONS=("1" "2" "3" "4" "5" "6" "7" "8" "9" "10" "11" "12")

sid=0
spaces=()
for i in "${!SPACE_ICONS[@]}"; do
	sid=$(($i + 1))

	space=(
		space=$sid
		icon="${SPACE_ICONS[i]}"
		label.padding_right=20
		icon.highlight_color=$WHITE
		label.color=$GREY
		label.highlight_color=$BLUE
		label.font="sketchybar-app-font:Regular:16.0"
		label.y_offset=-1
		script="$PLUGIN_DIR/space.sh"
	)

	sketchybar --add space space.$sid e \
		--set space.$sid "${space[@]}"
done

space_windows=(
	padding_left=0
	padding_right=0
	icon.padding_left=0
	icon.padding_right=0
	icon.background.color=$BAR_COLOR
	label.drawing=off
	display=active
	script="$PLUGIN_DIR/space_windows.sh"
)

sketchybar --add item space_windows e \
	--set space_windows "${space_windows[@]}" \
	--subscribe space_windows space_windows_change
