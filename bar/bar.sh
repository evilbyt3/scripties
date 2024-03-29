#!/bin/bash

# ^c$var^ = fg color
# ^b$var^ = bg color

interval=0

# load colors!
. ~/.local/bin/bar/themes/cyber

cpu() {
  cpu_val=$(grep -o "^[^ ]*" /proc/loadavg)

  printf "^c$black^ ^b$pink^ CPU"
  printf "^c$white^ ^b$grey^ $cpu_val"
}

pkg_updates() {
  #updates=$(doas xbps-install -un | wc -l) # void
  updates=$(checkupdates | wc -l)   # arch , needs pacman contrib
  # updates=$(aptitude search '~U' | wc -l)  # apt (ubuntu,debian etc)

  if [ -z "$updates" ]; then
    printf "^c$green^  Fully Updated"
  else
    printf "^c$red^  $updates"" updates"
  fi
}

battery() {
  get_capacity="$(cat /sys/class/power_supply/BAT0/capacity)"
  printf "^c$blue^   $get_capacity"
}

mem() {
  printf "^c$yellow^^b$black^  "
  printf "^c$yellow^ $(free -h | awk '/^Mem/ { print $3 }' | sed s/i//g)"
}

network() {
  [ -n "$(nmcli -a | grep 'Wired connection')" ] && CONNAME="wired:"
  [ -n "$(nmcli -t -f active,ssid dev wifi | grep '^yes')" ] && CONNAME="wifi:"
  PRIVATE=$(nmcli -a | grep 'inet4 192' | awk '{print $2}')

  if [ "$CONNAME" = "" ]; then # we don't have a connection
    printf "^c$black^ ^b$red^ 📡 ^d^%s" " ^c$white^Disconnected"
  else # we have a connection
    printf "^c$black^ ^b$green^ 📡 ^d^%s" " ^c$white^${CONNAME} ${PRIVATE}"
  fi
}

clock() {
  printf "^c$black^ ^b$darkblue^ 🕛 "
  printf "^c$black^^b$blue^ $(date '+%a %I:%M %p') "
}

vpn() {
  status="^c$black^ ^b$yellow^ VPN ^b$grey^"
  if [ -n "$(nordvpn status | cut -d: -f2 | grep Disconnected)" ]; then
    status+="^c$yellow^ off "
  else
    country="$(nordvpn status | grep Country | cut -d: -f2)"
    flag="$(cat /usr/share/rofi-emoji/all_emojis.txt | grep $country | awk '{print $1}')"
    status+="^c$green^ $country "
  fi
  status+="^b$black^"
  printf "${status}"
}

while true; do
  [ $interval = 0 ] || [ $(($interval % 3600)) = 0 ] && updates=$(pkg_updates)
  interval=$((interval + 1))

  sleep 1 && xsetroot -name "$(vpn) $updates $(battery) $(cpu) $(mem) $(network) $(clock)"
done
