#!/bin/bash

export DISPLAY=:0.0
export $(dbus-launch) 

batt_lvl=$(acpi -b | grep -P -o '[0-9]+(?=%)')
is_charging=$(acpi -b | grep -c "Charging")
is_full=$(acpi -b | grep -c "Full")

if [[ $is_charging -eq 1 && $batt_lvl -eq 100 ]] || [ $is_full -eq 1 ]; then
    dunstify -a "bat" -u "high" "🔋 Battery is full" && espeak "Unplug the charger you filthy human"
fi

if [[ $is_charging -eq 0 && batt_lvl -lt 30 ]]; then
    dunstify -a "bat" -u "normal" "🔋 Battery is below 30%"
fi

if [[ $is_charging -eq 0 && batt_lvl -lt 10 ]]; then
    dunstify -a "bat" -u "high" "⚠️   Battery is at 10%" && espeak "Plug the charger or I will die man"
fi
