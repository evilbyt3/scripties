#!/bin/bash
now_date=$(date +%Y%m%d)
EXCLUDES_PATH="$HOME/.excludes"
SOURCE=$HOME/home-backup-$now_date
DEST="pi_bak::/backupd/weekly/"

dunstify -a "homebak.sh" -u normal "☁️   Home backup initialized..."

# Compress it up
tar -cpzf $SOURCE --exclude=home-backup-$now_date.tar.gz --exclude-from=$EXCLUDES_PATH --warning=no-file-changed .

# Send it to the pi
rsync -az --delete $SOURCE $DEST && dunstify -a "homebak.sh" -u normal "🏁  Backup job finished"

# Remove tarball
shred -zun 5 $SOURCE

# rdiff-backup --terminal-verbosity 8 --print-statistics --exclude-globbing-filelist $EXCLUDES_PATH $HOME/  $DEST_PATH && \



