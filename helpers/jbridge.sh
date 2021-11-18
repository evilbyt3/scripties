#!/bin/bash

# -- INFO --
# Import md/txt files to jrnl list
# helper script for 

function panic {
	echo "[!] $1" && exit 1
}

TFILE="$1"
JLIST="$2"
echo $TFILE $JLIST

# check if file exists 
# TODO: Prompt to creeate
[[ ! -s $TFILE ]] && panic "provided file doesn't exists"

# check file format
if ! file -ib "$TFILE" | grep -q text; then
	panic "unsupported format"
fi

# import txt/md to jrnl file w title as slug
jrnl $JLIST "$TFILE" 		# add header
jrnl $JLIST < "$TFILE"	# contents #TODO: Maybe add for every line a new item?




