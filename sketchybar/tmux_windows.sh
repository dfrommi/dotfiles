#!/bin/bash

# Get the active session
active_session=$(tmux list-sessions -F "#{session_name}" -f "#{session_attached}")
current_window=$(tmux list-windows -F '#I' -f '#{window_active}' -t "$active_session")

# Get all windows of the active session safely and store them in an array
IFS=$'\n' read -d '' -r -a windows < <(tmux list-windows -F '#W' -t "$active_session")

# Initialize the sketchybar command
sketchybar_params=""

# Iterate over a fixed set of 9 tab slots
for i in {0..8}; do
  window_name="${windows[$i]}" # Get the window at position $i (array index starts from 0)

  echo "$active_session $current_window $window_name"

  if [ -z "$window_name" ]; then
    # If there's no window for this index, turn drawing off
    sketchybar_params+="--set tab.$((i + 1)) drawing='off' "
  else
    # Set colors based on whether the window is active
    if [ "$i" = "$current_window" ]; then
      label_color='0xff8aadf4' # Active window label color
      icon_color='0xffcad3f5'  # Active window icon color
      border_width=1
      icon_border_width=2
    else
      label_color='0xff939ab7' # Inactive window label color
      icon_color='0xff939ab7'  # Inactive window icon color
      border_width=0
      icon_border_width=0
    fi

    # Collect parameters for this tab
    sketchybar_params+="--set tab.$((i + 1)) label=\"$window_name\" \
                                     icon=\"$i\" \
                                     drawing='on' \
                                     background.border_width=$border_width \
                                     icon.background.border_width=$icon_border_width \
                                     label.color='$label_color' \
                                     icon.color='$icon_color' "
  fi
done

eval "sketchybar $sketchybar_params"
