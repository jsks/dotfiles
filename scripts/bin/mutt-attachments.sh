#!/usr/bin/env zsh
#
# Used by mutt mailcap
###

if [[ $OSTYPE == "darwin" ]]; then
    open $1
else
    xdg-open $1
fi
