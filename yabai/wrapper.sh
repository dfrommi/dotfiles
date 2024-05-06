#!/bin/bash

YABAI_USER=$(ls /tmp/yabai_*.socket | cut -d '_' -f 2 | cut -d '.' -f 1)

USER=$YABAI_USER /opt/homebrew/bin/yabai $@
