#!/bin/bash
# ============================================================
#  set-wallpaper.sh — sets wallpaper + generates colours via pywal
#  Usage: set-wallpaper.sh /path/to/image.jpg
# ============================================================

IMAGE="${1:-$HOME/Pictures/wallpapers/flower.jpg}"

if [[ ! -f "$IMAGE" ]]; then
  echo "File not found: $IMAGE"
  exit 1
fi

# Generate colour scheme from wallpaper
wal -i "$IMAGE" -n --backend haishoku 2>/dev/null || \
wal -i "$IMAGE" -n 2>/dev/null

# Set wallpaper on all outputs
swaymsg "output * bg $IMAGE fill"

echo "Wallpaper set: $IMAGE"
