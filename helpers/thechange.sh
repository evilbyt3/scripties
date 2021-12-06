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
#       - dwm                   
#       TODO:
#        - tmux
#        - rofi
#        - wallpaper
#        - make another helper script 4 generating themes for all the programs from only 1 file

DUNSTC="${XDG_CONFIG_HOME:-$HOME/.config}/dunst"
ALACRC="${XDG_CONFIG_HOME:-$HOME/.config}/alacritty"
BARC="${XDG_SCRIPTS_DIR:-$HOME/.local/bin}/bar"
VIMC="${XDG_CONFIG_HOME:-$HOME/.config}/nvim/lua/custom"
COLC="${XDG_CONFIG_HOME:-$HOME/.config}/colorls"
DWMC="$HOME/.local/src/chadwm"

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
theme="$(echo "uwu|dracula|cyber|nord|onedark|gruvbox" | rofi -dmenu -sep "|" -p "🎨 Choose a color theme:")"

# Change dunst theme
change_dunst "$theme"

# Change alacritty theme
sed -i "s/colors: \*.*/colors: *$theme/g" "$ALACRC/alacritty.yml"

# Change statusbar theme & restart
sed -i "s/themes.*/themes\/$theme/g" "$BARC/bar.sh"
pgrep bar.sh && killall -q bar.sh 
bar.sh &

# Change dwm theme (will take effect upon login)
sudoPass="$(zenity --password --title 'sudo password')"
cd "$DWMC" && sed -i "s/#include \"themes.*\"/#include \"themes\/$theme.h\"/g" "$DWMC/config.def.h" && echo "$sudoPass" | sudo -S make clean install

# Change colorls theme
cat "$COLC/themes/$theme" > "$COLC/dark_colors.yaml"

# Change NvChad color theme
[ "$theme" == "dracula" ] && theme="chadracula"
[ "$theme" == "cyber" ] && theme="tokyonight"
sed -i "s/theme = .*/theme = \"$theme\",/g" "$VIMC/chadrc.lua"
