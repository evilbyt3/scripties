#!/bin/bash

setbg_dir="${HOME}/res/pix"

# Simple error function
err() { 
  printf 'Error: %s\n' "$1"
  exit 1
}

# Helper script to set the background
setbg() {
  xwallpaper --stretch "$1" && betterlockscreen -u "$1"
}

choice=$(printf "Set|Random|Exit" | rofi -dmenu -sep "|" -p "What would you like to do?")
case "$choice" in 
  "Set") 
    wallpaper="$(sxiv -t -o "${setbg_dir}")"
    echo "$wallpaper" > "$HOME"/.cache/wall
    setbg "$wallpaper";;
  "Random") 
    alid_paper="No"
    until [ "$valid_paper" = "Yes" ]; do
      pidof "xwallpaper" && killall "xwallpaper" 
      wallpaper="$(find "${setbg_dir}" -type f | shuf -n 1)"
      setbg "$wallpaper" &
      cp "$wallpaper" "$HOME/.cache/wall"
      valid_paper="$(printf "Yes|No" | rofi -dmenu -sep "|" -p "Do you like the new wallpaper?")"
    done;;
  "Exit") echo "Program terminated" && exit 0;;
  *) err "Invalid choice";;
esac
