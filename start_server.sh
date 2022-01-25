#!/usr/bin/env bash
set -B
### Settings
TIMEOUT=60
UPDATE_PURPUR=true
BACKUP=true
UNIVERSE=$MC_DIR/universe
BACKUP=$MC_DIR/backup
MC_DIR=~/Minecraft
### Do not modify past here
export TIMEOUT
RED=$(tput setaf 1)
BLUE=$(tput setaf 20)
BOLD=$(tput bold)
WHITE=$(tput setaf 15)
MAGENTA=$(tput setaf 5)
RESET=$(tput sgr0)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
SERVERS=()
AIKAR='-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true'
ZGC=
out(){
	for X in "$@"; do
		echo -en "${BLUE}${BOLD}==>${RESET} ${WHITE}${X} "
		echo "$RESET"
	done
}
abort(){
	local SOFT
	while [[ $# -ge 1 ]]
	do
		if [[ $1 = '-s' || $1 = '--soft' ]]
		then
			local SOFT=true
			shift
			continue
		elif [[ $1 != ?* ]]
		then
			exit 2
		else
			local SOFT=false
			true
			break
		fi
	done
	echo -en "$MAGENTA${BOLD}==> ${RED}${*}\nAborting ..."
	echo "$RESET"
	# shellcheck disable=SC2034
	SOFT=true && exit 1
}
if [[ $# = 0 ]]
then
  read -p "$GREEN$BOLD==>$RESET $WHITE Which server(s) do you want to start? (lobby|survival|ctl|fabric|velocity) " -a SERVERS
	if [[ $? -eq 142 ]]
	then
		abort "No activity for 1 minute."
	fi
	set ${SERVERS[*]}
	SERVERS=()
fi
until [[ $# -eq 0 ]]
do
	case "$1" in
		lobby|survival|ctl|fabric)
			SERVERS+=("$1")
			;;
		velocity)
			VELOCITY=true
		*)
			warn "$1 is not a valid server and will be ignored."
			;;
	esac
	shift
done
if [[ -z $VELOCITY ]]
then
	VELOCITY=false
fi
pushd $MC_DIR
pushd ./bin
if [[ $BACKUP == 'true' ]]
then
	MC_DIR=~/Minecraft

	cd $UNIVERSE
	ARGS=-dbrST
	for SERVER in $@
	do
	  cd $SERVER
	  if [[ -f "$OLD_ZIP" ]]
	  then
	    ARGS+=
	  fi
	  zip $ARGS $(date "+%Y-%d-%m %H:%M")
	done
popd
tmux new -ds SERVERS
tmux renamew -t
