#!/bin/bash
# Screenshot selected area → save to ~/Pictures + copy to clipboard
mkdir -p ~/Pictures/screenshots
FILE=~/Pictures/screenshots/$(date +%Y-%m-%d_%H-%M-%S).png
grim -g "$(slurp)" "$FILE" && \
  wl-copy < "$FILE" && \
  notify-send "Screenshot saved" "$FILE"
