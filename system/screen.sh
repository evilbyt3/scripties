#!/bin/bash

opts="$HOME/archive/pix/screenshots|$HOME/admin/mounts/mind_matrix/static"
choice=$(echo "$opts" | rofi -dmenu -sep "|" -p "Where to store?")
fname=$(echo "$(date +%s)" | rofi -dmenu -p "Filename?")

maim -s "$choice/$fname.png" && dunstify -u low "📸  Took screenshot"
