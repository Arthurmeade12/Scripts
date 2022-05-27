#!/usr/bin/env bash
set -Bo pipefail
CONFIG=~/Minecraft/config.sh
. $CONFIG
. ~/Minecraft/env.sh
server_running(){
	if [[ ! -d $STATUSDIR ]]
	then
		mkdir $STATUSDIR
		for FIX in {ctl,lobby,survival,velocity,quilt,serversync}
		do
			touch $STATUSDIR/${FIX}.txt
			echo 'false' > $STATUSDIR/${FIX}.txt
		done
	fi
	if grep 'false' < $STATUSDIR/${1}.txt 1>/dev/null
	then
		out "${RED}Error: ${1^} is not running.${RESET}"
		return 1
	else
		echo 'false' > $STATUSDIR/${1}.txt
	fi
}
if [[ $# = 0 ]]
then
	#shellcheck disable=SC2048 disable=SC2086
  read -rp "$GREEN$BOLD==>$RESET $WHITE Which server(s) do you want to stop? (Lobby|Survival|Ctl|Quilt|Velocity|ServerSync) " -a SERVERS
	if [[ $? -eq 142 ]]
	then
		abort "No activity for 1 minute."
	fi
	#shellcheck disable=SC2048 disable=SC2086
	set ${SERVERS[*],,}
	SERVERS=()
fi
until [[ $# -eq 0 ]]
do
	case "$1" in
		lobby|survival|ctl|quilt|velocity)
			SERVERS+=("$1")
			;;
		*)
			warn "$1 is not a valid server and will be ignored."
			;;
	esac
	shift
done
out "Stopping the following servers: \n${SERVERS[*]}\n"
if ! tmux has -t SERVERS 2>/dev/null
then
  abort "No servers are running!"
fi
for Z in ${SERVERS[*]}
do
	server_running $Z || continue
  case "$Z" in
  velocity)
    tmux send -t SERVERS:Velocity 'alert The whole server network is stopping in 15 seconds!
    '
    sleep 15
		out "Please wait 15 seconds ..."
    tmux send -t SERVERS:Velocity 'end
    '
    ;;
  quilt)
    if [[ $AUTOSERVERSYNC = true ]]
    then
      SERVERS+=(serversync)
    fi
    tmux send -t SERVERS:Quilt 'say The server is stopping in 10 seconds!
    '
    tmux send -t SERVERS:Quilt "say You can still play on the other servers though, if they're running.
    "
		out "Please wait 10 seconds ..."
		sleep 10
    tmux send -t SERVERS:Quilt 'stop
    '
    ;;
	serversync)
		out 'Stopping ServerSync ...'
		tmux killw -t SERVERS:ServerSync
		;;
  lobby|survival|lobby)
    tmux send -t SERVERS:"${Z^}" 'say The server is stopping in 10 seconds!
    '
    tmux send -t SERVERS:"${Z^}" "say You can still play on the other servers though, if they're running.
    "
		out "Please wait 10 seconds ..."
		sleep 10
    tmux send -t SERVERS:"${Z^}" 'stop
    '
    ;;
  esac
	reset $Z
  out "Stopped server ${Z^}!"
done
