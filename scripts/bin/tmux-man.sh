#!/usr/bin/env zsh
# 
# Convenience script for tmux to search man pages by title 
#
#   bind-key '/' display-popup -E "exec ~/bin/tmux-man.sh"
#
###

setopt err_exit

match=$(man -k . | fzf --preview='man $(tr -d "()" <<< {2}) {1}' \
                        --nth="..2" \
                        --tiebreak="chunk" \
                        --reverse)

man $(awk '{gsub("[()]", "", $2); print $1 "." $2}' <<< $match)
