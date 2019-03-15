#!/bin/zsh

setopt err_return

mbsync $1
notmuch new

if [[ -n $2 ]]; then
    ~/bin/nprint Mutt "New Mail $2 [$1]"
fi

