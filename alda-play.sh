#!/usr/bin/env bash
[[ -z "${1}" ]] && echo 'ERROR: Must play file.' 1>&2 && exit 1
while true
do
    echo '==> Hit enter to play file again, or anything else to quit.'
    read ANSWER
    [[ "${ANSWER}" ]] && break
    alda play -f "${1}"
done
