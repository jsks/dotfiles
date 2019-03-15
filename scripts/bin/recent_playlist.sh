#!/bin/zsh
# Generate a playlist of most recently added tracks

typeset -a SONGS

PLAYLIST=~/.config/mpd/playlists/recent_add.m3u
MUSIC_DIR=~/music
DAYS=30

for i in $MUSIC_DIR/**/*(.m-$DAYS); do
    [[ ${i:e} == "mp3" ]] && SONGS+=($i)
done

<<< $SONGS > $PLAYLIST
