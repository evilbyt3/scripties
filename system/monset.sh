#!/bin/bash
# A simple and nasty bash script to 
# quickly switch between monitors

screens=$(xrandr | grep " connected " | awk '{print $1}') && read disp1 disp2 <<< $(echo $screens | tr '\n' ' ')

case $(echo -e "$screens\nBoth" | rofi -dmenu) in
	Both)
		xrandr --output $disp2 --mode 3440x1440 --left-of $disp1 && setbg.sh;;
	$disp1)
		xrandr --output "$disp2" --off
		xrandr --output "$disp1" --mode 1920x1080 --primary;;
	$disp2)
		xrandr --output "$disp1" --off
		xrandr --output "$disp2" --mode 1920x1080 --primary;;
	*)
		echo "Invalid option" && exit 1;;
esac



