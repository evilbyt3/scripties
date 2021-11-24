#!/bin/bash
#     _..__.          .__.._
#  .^"-.._ '-(\__/)-' _..-"^.
#         '-.' oo '.-'
#            `-..-'
#   Author : vlaghe
#   Website: vlaghe.com
#
#   Description
#   -----------
#   Quickly download videos, images, music and files
#   with rofi
#
#   TODO
#   ----
#   Refactor me (later?)

# Change these for your dir struct
BASE="$HOME/res"
MUZ_DIR="$BASE/muz"
PIX_DIR="$BASE/pix"
VID_DIR="$BASE/vids"


# Helper function to easily 
# display msg and exit
function err() {
  echo "[!] $1" && exit 1
}

# Will handle a youtube link
# Options:
#   audio         retrieve only the audio (defaults to this)
#   video         retrieve video
#   thumbnail     retrieve only thumbnail
#   all           retrieve all of the above
#   playlist ?    if it is a playlist download it
#       video     video only 
#       audio     audio only (defaults to this)
#
# What a mess bro
# TODO: isn't working with playlist videos: https://www.youtube.com/watch?v=gBUKbTLyGgE&list=PL0IYNTdrSN93QXM4oKcAXPYs6byExxDPm&index=38
function handle_yt() {

  opt=$(echo "aud|vid|thumb|playlist|all" | rofi -dmenu -sep "|" -p "Select type (default = aud)")
  case $opt in
    'vid') 
      OUT="$VID_DIR/%(title)s.%(ext)s"
      notif="🎥  video"
      args="--embed-subs --add-metadata";;

    'thumb') 
      OUT="$PIX_DIR/yt/%(title)s.%(ext)s"
      notif="⛰  thumbnail"
      args="--write-thumbnail --skip-download";;

    'all') 
      OUT="$BASE/%(title)s.%(ext)s"
      args="--write-description --write-info-json --write-annotations --write-auto-sub --write-thumbnail";;

    'playlist') 
      args="--yes-playlist --ignore-errors "
      playlist_opt=$(echo "aud|vid" | rofi -dmenu -sep "|" -p "Select type (default = aud)")
      notif="🎥 playlist "

      case $playlist_opt in
        'aud') 
          OUT="$MUZ_DIR/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s"
          notif+="audio only"
          args+="-x --embed-thumbnail --audio-quality 0";;
        'vid') 
          OUT="$VID_DIR/youtube/%(playlist_title)s/%(playlist_index)s - %(title)s.%(ext)s"
          args+="--embed-subs --add-metadata";;
      esac
      ;;

    *) 
      OUT="$MUZ_DIR/%(title)s.%(ext)s"
      notif="🎼  music "
      args="-x --embed-thumbnail --audio-quality 0 --audio-format mp3"
  esac

  echo "youtube-dl -o \"$OUT\" $args \"$target\""
  youtube-dl -o "$OUT" $args "$target" && notif_msg="$notif downloaded" || notif_msg="$notif could't download"
  dunstify -a "youget" -u low "$notif_msg"

}



# Retrieve clipboard contents
target="$(xclip -o)"

# Check if it's a link
# Stole it from https://stackoverflow.com/questions/3183444/check-for-valid-link-url
regex='^(https?)://[-A-Za-z0-9\+&@#/%?=~_|!:,.;]*[-A-Za-z0-9\+&@#/%=~_|]$'
[[ ! $target =~ $regex ]] && err "Not a link"

# If it's a youtube link, handle it properly
domain=$(echo "$target" | awk -F[/:] '{print $4}')
[[ $domain =~ "www.youtube.com" ]] && handle_yt

