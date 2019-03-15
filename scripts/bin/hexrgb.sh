#!/bin/zsh
#
# Convert hex to rgb 
###

[[ ! -f $1 ]] && { printf "Invalid file, $1.", exit 115 }

FILE=$(<$1)
typeset -A COLORS

for i in ${(f@)FILE}; do
    [[ ${i[1]} =~ '#'\|'!' ]] && continue
    for k v in ${(SMz)i##[[:alnum:]]*}; do
        COLORS[$k]=$v
    done
done

for i in ${(@U)COLORS}; do
    printf "${(k)COLORS[(r)$i]} rgb:%d/%d/%d\n" 0x$i[2,3] 0x$i[4,5] 0x$i[6,7]
done

