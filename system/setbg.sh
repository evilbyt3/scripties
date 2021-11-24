#!/bin/bash
#
# Original Author : Luke Smith (lukesmith.xyz)
# Modified by	  : vlaghe (vlaghe.com)
#
# Description
# -----------
# 	This script does the following:
#	        Run by itself, set the wallpaper (at X start).
#		If given a file, set that as the new wallpaper.
#		If given a directory, choose random file in it.
#		If wal is installed, also generates a colorscheme.
#		If betterlockscreen is installed, use it when wallpaper is changed

# Location of link to wallpaper link.
bgloc="${XDG_DATA_HOME:-$HOME/.local/share/}/bg"

trueloc="$(readlink -f "$1")" &&
case "$(file --mime-type -b "$trueloc")" in
  image/* ) ln -sf "$(readlink -f "$1")" "$bgloc" && dunstify -a "setbg.sh" -u low "⛰<fe0f> Changing wallpaper..." ;;
  inode/directory ) ln -sf "$(find "$trueloc" -iregex '.*.\(jpg\|jpeg\|png\|gif\)' -type f | shuf -n 1)" "$bgloc" && dunstify -a "setbg.sh" -u low "⛰<fe0f> Choosing random wallpaper..." ;;
  *) notify-send "Error" "Not a valid image." ; exit 1;;
esac

# If pywal is installed, use it.
# command -v wal >/dev/null 2>&1 &&
# 	wal -i "$trueloc" -o "${XDG_CONFIG_HOME:-$HOME/.config}/wal/postrun" >/dev/null 2>&1 &&
# 	pidof dwm >/dev/null && xdotool key super+F12

xwallpaper --stretch "$bgloc" 

# If betterlockscreen installed, use it
command -v betterlockscreen >/dev/null 2>&1 && betterlockscreen -u "$bgloc"
