#!/bin/bash
# 
# Website: vlaghe.com 

# Description 
# -----------
# This is a simple bash script used to backup
# the profile for the Brave Browser
# 
# It will tar and encrypt the dir found at
# $BRAVE_CONFIG

BRAVE_CONFIG="${XDG_CONFIG_HOME:-$HOME/.config}/BraveSoftware"
flashred=$(tput setab 0; tput setaf 1; tput blink)
none=$(tput sgr0)
err() {
  echo -e $flashred"ERROR: "$none"$1" && exit 1
}

# Check if any Brave procs are running
[[ -n "$(pgrep -f brave)" ]] && err "Close your Brave instances in order to run this script"

# Check if the profile settings dir exists
[[ ! -d $BRAVE_CONFIG ]] && err "Brave profile directory not found, check your ${XDG_CONFIG_HOME:-$HOME/.config}"

 # By default, tar it & encrypt
outfname=${1:-brave-bak.tar.gz}
tar -czvf $outfname $BRAVE_CONFIG && gpg -c $outfname && shred -zfu -n 10 $outfname && exit 0




