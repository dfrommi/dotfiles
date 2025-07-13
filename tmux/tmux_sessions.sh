#!/bin/bash

# Get the active session
active_session=$(tmux list-sessions -F "#{session_name}" -f "#{session_attached}" 2>/dev/null)

# Initialize the sketchybar command
tmux_params=""

# Iterate over a fixed set of 9 tab slots
for session_name in $(tmux ls -F '#S'); do
  # Set colors based on whether the session is active
  if [ "$session_name" = "$active_session" ]; then
    fg_color='#1e1e2e' # Active session label color
    bg_color='#fab387' # Active session icon color
  else
    fg_color='#1e1e2e' # Inactive session label color
    bg_color='#cba6f7' # Inactive session icon color
  fi

  # Collect parameters for this tab
  #tmux_params+="#[fg=$fg_color,bg=$bg_color]#[reverse]█#[noreverse]$session_name#[reverse]█#[noreverse]"
  tmux_params+="#[fg=$fg_color,bg=$bg_color]█ $session_name █"
done

echo $tmux_params
