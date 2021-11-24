#!/bin/bash

# Description
# -----------
#
# Mount/Umount your encrypted obsidian
# vault on the go. A helper script
#
# NOTE: This script is called as a keybind by i3 
# (see ~/.config/i3/config file)

ENC_VAULT="$HOME/area/mind_matrix"
MOUNT_P="$HOME/area/mounts/mind_matrix"

# Mount encrypted dir
gocryptfs -extpass "zenity --password" "$ENC_VAULT" "$MOUNT_P"

# Start obsidian and wait for it to close
obsidian &
BACK_PID=$!
wait $BACK_PID

# Unmount
fusermount -u "$MOUNT_P"



