#!/bin/bash
# Preview a Xdefaults color scheme
# Usage: themeview.sh [FILE]
####

if [[ ! -f "$1" ]]; then 
    echo "Invalid file, $1"
    exit 1
fi

# Set to whatever color script normally used.
# If unset, a simple array of bars will be printed
# to preview the new color scheme.
# COLORCMD="colortheme"

exec < /dev/tty
oldstty=$(stty -g)
stty raw -echo min 0
echo -ne "\033]4;0;?;1;?;2;?;3;?;4;?;5;?;6;?;7;?;8;?;9;?;10;?;11;?;12;?;13;?;14;?;15;?\007"

# Save the current color theme
orig_colors=()
while read -t 0.1 -d ';' line; do
    if [[ "$line" =~ rgb* ]]; then
        orig_colors+=($(sed 's/[^rgb:0-9a-f/]//g' <<< ${line%4}))
    fi
done

stty $oldstty

# Parse given color file
new_colors=()
while read line; do
    if [[ ${line:0:1} == "#" ]]; then
        continue
    elif [[ $line =~ color[0-9] ]]; then
        new_colors[$(sed -e 's/.*r//;s/[:|=].*//' <<< $line)]=$(tr -d ' ' <<< ${line#*[:|=]})
    fi
done  < "$1"

# Set the new color table
for i in {0..15}; do
    echo -ne "\033]4;$i;${new_colors[$i]}\007"
done

if [[ -n $COLORCMD ]]; then
    $COLORCMD
else
    for i in {30..37}; do
        echo -ne "\033[${i}m███"
    done
    echo
    for i in {30..37}; do
        echo -ne "\033[${i}m\033[1m███"
    done

    echo -ne "\033[0m"
fi

echo
read -p "Press enter to continue..."

# Restore our old theme
for i in {0..15}; do
    echo -ne "\033]4;$i;${orig_colors[$i]}\007"
done