#!/bin/zsh

# Run "/etc/X11/xinit/xinitrc.d/"
if [ -d /etc/X11/xinit/xinitrc.d ]; then
    for i in /etc/X11/xinit/xinitrc.d/*; do
        if [ -x "$i" ]; then
            . "$i"
        fi
    done
fi

# X Settings
xrdb -load ~/.Xresources
setxkbmap -option caps:escape -option altwin:swap_alt_win -layout us,se -option grp:alt_shift_toggle

# Screen lock
xautolock -noclose -time 5 -locker "i3lock -c '#d1d1d1'" -nowlocker "i3lock -c #d1d1d1" -notify 5 -notifier "notify-send 'Screen will lock in 3 Seconds'" -corners 000+ -cornerdelay 1 &

# F.Lux
xflux -l 59.9 -g 10.8

# Start tmux
[[ -z $(pgrep tmux) ]] && tmux new-session -d &

# Set wallpaper
setbg -s ~/Downloads/KubinOriental.jpg

# Volume daemon
volnoti -t 2 &

# Volume keybindings
sxhkd &

# Compositor
picom --config ~/.config/picom/picom.conf &

exec ${1:-awesome}
