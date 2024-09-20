#!/bin/bash

# Get the active session
active_session=$(tmux list-sessions -F "#{session_name}" -f "#{session_attached}")

# Get all windows of the active session safely and store them in an array
IFS=$'\n' read -d '' -r -a windows < <(tmux list-windows -F '#W' -t "$active_session")

# Initialize the sketchybar command
sketchybar_params=""

# Iterate over a fixed set of 9 tab slots
for i in {1..9}; do
	window_name="${windows[$((i - 1))]}" # Get the window at position $i (array index starts from 0)

	if [ -z "$window_name" ]; then
		# If there's no window for this index, turn drawing off
		sketchybar_params+="--set tab.$i drawing='off' "
	else
		# Set colors based on whether the window is active
		current_window=$(tmux display-message -p '#I')
		if [ "$i" = "$current_window" ]; then
			label_color='0xff8aadf4' # Active window label color
			icon_color='0xffcad3f5'  # Active window icon color
		else
			label_color='0xff939ab7' # Inactive window label color
			icon_color='0xff939ab7'  # Inactive window icon color
		fi

		# Collect parameters for this tab
		sketchybar_params+="--set tab.$i label=\"$window_name\" \
                                     icon=\"$i\" \
                                     drawing='on' \
                                     label.color='$label_color' \
                                     icon.color='$icon_color' "
	fi
done

eval "sketchybar $sketchybar_params"
