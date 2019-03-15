#!/bin/zsh
# Toggle dpms on/off

xset -q | grep -q "DPMS is Enabled" && {
	xset -dpms 
	xset s off
	exit
}
xset -q | grep -q "DPMS is Disabled" && { 
	xset +dpms
	xset s on
}
