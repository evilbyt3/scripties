#!/bin/bash

# Description
# -----------
#
# Mount/Umount your encrypted obsidian
# vault on the go. A helper script
#
# NOTE: This script is usually called as a keybind by the wm
# (see ~/.config/i3/config file OR ~/.local/src/chadwm/config.def.h)

ENC_VAULT="$HOME/area/mind_matrix"
MOUNT_P="$HOME/area/mounts/mind_matrix"

# Mount encrypted dir
gocryptfs -extpass "zenity --password" "$ENC_VAULT" "$MOUNT_P" || { dunstify -u critical -a "obsdstart" "😥 Couldn't decrypt vault..." && exit 1; }

# Start obsidian and wait for it to close
obsidian &
BACK_PID=$!
wait $BACK_PID

# Unmount
fusermount -u "$MOUNT_P"
