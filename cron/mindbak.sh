#!/bin/bash

VAULT="$HOME/area/mind_matrix"
GITSERV="192.168.1.188"

function panic {
    echo "[!] $1" && dunstify -a "mindbak" -u critical "❕$1 @ $GITSERV" && exit
}

cd "$VAULT" && dunstify -a "mindbak" -u low "🌩  Backing up vault to local git..."
CHANGES_EXIST="$(git status --porcelain | wc -l)"
#echo $CHANGES_EXIST
[[ -z "$CHANGES_EXIST" ]] && exit 0

# Check if local git server is reachable
#ping -c 1 $GITSERV &> /dev/null || panic "Can't reach git server"

git add . && git commit -q -m "Last Sync: $(date +"%Y-%m-%d %H:%M:%S")"
#git pull origin master && git add . && git commit -q -m "Last Sync: $(date +"%Y-%m-%d %H:%M:%S")" # &&
    #git push -q bak master && dunstify -a "mindbak" -u low "Finished backing up mind"


