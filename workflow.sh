#!/usr/bin/env bash
set -euo pipefail
RUN_SUDO_PROGRAMS=false
SSH=false
ITERM=true
if tmux has -t center &>/dev/null
then
  echo "ERROR: Session 'center' already exists!"
  exit 1
else
  :
fi

tmux new -ds 'center'
tmux rename-window 'htop'
if [[ "$RUN_SUDO_PROGRAMS" = 'true' ]]
then
  tmux send -t 'btop' 'sudo btop
  '
else
  tmux send -t 'btop' 'btop
  '
fi
tmux neww -n spt 'spt
'
case $SSH in
true)
  tmux neww -n ssh 'ssh Arthur@manjaro
  '
  ;;
false)
  :
  ;;
esac
tmux neww -n 'work'
case "$ITERM" in
true)
  tmux -CC attach -t center
  ;;
false)
  tmux attach -t center
  ;;
esac
exit 0
