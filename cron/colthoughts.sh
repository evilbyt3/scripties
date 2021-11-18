#!/bin/bash

DAILIES_PATH=""
THOUGHT_CLOUD=""
fnr=$(ls "$DAILIES_PATH" | wc -l)

sed -i '11,$d' "$THOUGHT_CLOUD"
for file in "$DAILIES_PATH/"*; do
    # https://stackoverflow.com/questions/1187354/excluding-first-and-last-lines-from-sed-start-end
    thought=$(sed -n "1,/## Thoughts/d;/---/q;p" < "$file") 
    [ -z "$thought" ] && continue
    day_date=$(basename "$file") 
    printf "### %s\n%s\n" "$day_date" "$thought" >> "$THOUGHT_CLOUD"
done
echo -e "\n---" >> "$THOUGHT_CLOUD"


# find "$DAILIES_PATH" -type f -exec cat "{}" \;


