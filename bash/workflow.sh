#!/usr/bin/env bash
set -euo pipefail
RUN_SUDO_PROGRAMS='false'
SSH='false'
SESSION='CENTER'
if tmux has -t CENTER 2>/dev/null
then
  echo "ERROR: Session 'center' already exists!"
  exit 1
fi

tmux new -ds "${SESSION}"
tmux rename-window 'Work'
if [[ "$RUN_SUDO_PROGRAMS" = 'true' ]]
then
  tmux neww -s "${SESSION}" -n 'Btop' 'sudo btop'
else
  tmux neww -s "${SESSION}" -n 'Btop' 'btop'
fi
[[ "${SSH}" = 'true' ]] && tmux neww -n iMac 'ssh arthurmeade12@meades-linux-imac'
tmux attach -t center
exit
