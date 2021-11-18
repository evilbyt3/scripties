#!/bin/bash
# 
#  Website: vlaghe.com 
#
#  Description 
#  -----------
#  Script to find all the sources within a vault
#  (looks for #source*) and move them to the 
#  specified directory
#  
#  Usage
#  -----
#  ./sourceme.sh <vault_path>
# 
# TODO:
#   [] Add a more reliable way to retrieve the #source files
#   [] Add input/output file options
#   [] Help/Usage msg

VAULT_PATH=${1:-"$HOME/admin/mind_matrix"}
OUT_DIR="$HOME/admin/mind_matrix/🗞️ Sources"

# Pretty dumb but whatevs
files=$(grep -r -l "#source" "$VAULT_PATH" | grep -v -e "Index" -e "Sources")
(
  IFS=$'\n'
  for f in $files; do
    mv $f $OUT_DIR
  done
)

