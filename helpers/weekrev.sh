#!/bin/bash
# 
# NOTE: Out of date script, haven't updated since 2020
#
# TODO:
#  [] Error check args
#  [] Notification when running/logging
#  [] Add help, description and usage
#  [] Maybe refactor the parsing, it's kinda retarded


VAULT_PATH=${1:-"$HOME/admin/mind_matrix/📒 Journal"}
update_review() {
  awk -v thought="$1" -v rels="$2" -v refs="$3" 'BEGIN{FS=OFS="|"}{$4=thought; $5=rels; $6=refs}1'
}

# Retrieve the current week note file & its content
week_file=$(find "$VAULT_PATH" -name "Week `date +%U` -- `date +%Y`.md")
content=$(cat "$week_file" | grep -A6 "| Mon |")

review=""
while read line; do

  # Retrieve each day note
  day_file="$VAULT_PATH/$(echo ${line} | sed 's/.*\[\([^]]*\)\].*/\1/g').md"
  [[ ! -f "$day_file" ]] && continue #echo "Couldn't find the '$day_file' file"

  # Parse the `Thoughts` section
  thought=$(sed -n '/## Thoughts/{
    :1
    n
    /<br>/q
    p
    b1
  }' "$day_file" | tr "\n" " ")

  # Parse the `Meta` section
  meta_section=$(sed -n '/|/,/|/p' "$day_file" | tail -n +3)
  refs=""; rels=""
  while read link; do
    ref=$(echo "$link" | awk -F"|" '{print $2}' | xargs | sed -r '/^\s*$/d')
    [[ -n "$ref" ]] && refs+="$ref "

    rel=$(echo "$link" | awk -F"|" '{print $3}' | xargs | sed -r '/^\s*$/d')
    [[ -n "$rel" ]] && rels+="$rel "
  done <<< "$meta_section"

  # Build the review table
  review+="$(echo "$line" | update_review "$thought" "$rels" "$refs")\n"
done <<< "$content"

# Append the table on the week's note based on the previous parsing
sed -i -e '/| Mon |/,+9d' "$week_file" && sed -i "/| --- |/a $review/" "$week_file"
echo "**Habit Score**: \- - - - - - - -" >> "$week_file"

exit 0



# Detect day files 
# Format : ddd -- yyyy-mm-dd.md
# Example: Fri -- 2021-03-12.md
#ape() {
#  awk -v var="$1" 'BEGIN{FS=OFS="|"}{'"$2"'=var}1'
#}

# Future TODO:
# Maybe make this a cron based on --week, --month, --year
# Automatically generate dirs and sort days/weeks/months accordingly
# Retrieve days of week from the `Week <w_nr_in_year> -- <year>` file
# Encrypt / Decrypt vaults (other script because linux philosophy)
