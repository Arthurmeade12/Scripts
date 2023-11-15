#!/usr/bin/env bash
if [[ "$(whoami)" != 'root' ]]
then
    printf '%s\n' 'Must be root (2)'
    exit 2
fi
while true
do
    printf '%s' ' ==> '
    #shellcheck disable=2162 ### Backslashes are fine.
    read INPUT
    #shellcheck disable=2086 ### We want globbing and word splitting.
    pacman -${INPUT}
done
