#!/bin/bash

# Get the active session
active_session=$(tmux list-sessions -F "#{session_name}" -f "#{session_attached}")

# Get all tmux sessions safely and store them in an array
IFS=$'\n' read -d '' -r -a sessions < <(tmux ls -F '#S')

# Initialize the sketchybar command
sketchybar_params=""

# Iterate over a fixed set of 9 tab slots
for i in {1..9}; do
  session_name="${sessions[$((i - 1))]}" # Get the session at position $i (array index starts from 0)

  if [ -z "$session_name" ]; then
    # If there's no session for this index, turn drawing off
    sketchybar_params+="--set window.$i drawing='off' "
  else
    # Set colors based on whether the session is active
    if [ "$session_name" = "$active_session" ]; then
      label_color='0xff8aadf4' # Active session label color
      icon_color='0xffcad3f5'  # Active session icon color
    else
      label_color='0xff939ab7' # Inactive session label color
      icon_color='0xff939ab7'  # Inactive session icon color
    fi

    # Collect parameters for this tab
    sketchybar_params+="--set window.$i label=\"$session_name\" \
                                     icon=\"$i\" \
                                     drawing='on' \
                                     label.color='$label_color' \
                                     icon.color='$icon_color' "
  fi
done

eval "sketchybar $sketchybar_params"
