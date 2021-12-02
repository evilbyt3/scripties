#!/bin/bash
#   _..__.          .__.._
#  .^"-.._ '-(\__/)-' _..-"^.
#         '-.' oo '.-'
#            `-..-'
#   Author : vlaghe
#   Website: vlaghe.com
#
#   Description
#   -----------
#   Change theme for funkydots:
#       - alacritty
#       - dunst
#       - statusbar
#       - nvim                        
#       - colorls
#       TODO:
#        - dwm                   
#        - tmux
#        - wallpaper

DUNSTC="${XDG_CONFIG_HOME:-$HOME/.config}/dunst"
ALACRC="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty"
BARC="${XDG_SCRIPTS_DIR:-$HOME/.local/bin}/bar"
VIMC="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/lua/custom"
COLC="${XDG_CONFIG_HOME:-$HOME/.config}/colorls"
DWMC="" # TODO:

change_dunst() {
  # Delete the current theme
  sed -i '/theme/Q' "$DUNSTC/dunstrc"

  # Add new color scheme
  new_theme=$(<"$DUNSTC/themes/$1")
  echo "$new_theme" >> "$DUNSTC/dunstrc"

  # Restart dunst
  pgrep dunst && killall -q dunst
  dunst &
}

# Prompt user to choose theme
theme="$(echo "uwu|dracula|nord|onedark|gruvbox" | rofi -dmenu -sep "|" -p "🎨 Choose a color theme:")"

# Change dunst theme
change_dunst "$theme"

# Change alacritty theme
sed -i "s/colors: \*.*/colors: *$theme/g" "$ALACRC/alacritty.yml"

# Change statusbar theme & restart
sed -i "s/themes.*/themes\/$theme/g" "$BARC/bar.sh"
pgrep bar.sh && killall -q bar.sh 
bar.sh &

# Change colorls theme
cat "$COLC/themes/$theme" > "$COLC/dark_colors.yaml"

# Change NvChad color theme
[ "$theme" == "dracula" ] && theme="chadracula"
sed -i "s/theme = .*/theme = \"$theme\",/g" "$VIMC/chadrc.lua"

