#!/usr/bin/env bash
set -euBo pipefail
### Settings
TIMEOUT='60'
MC_DIR=~/Minecraft
UPDATE_PURPUR='false'
BACKUP='false'
UNIVERSE="$MC_DIR/universe"
MC_DIR='~/Minecraft'
PROXY='false'
DATE='oops'
HOST='0.0.0.0'
VELOCITY='nope'
case "$PROXY" in
true)
	ONLINE=false
	;;
false)
	ONLINE=true
	;;
esac
declare -A CUSTOMJAVAOPTIONS=(
	[lobby]='-Xms1536M -Xmx3G -Xdock:name=Lobby -DGeyserSkinManager.ForceShowSkins=true -Xdock:icon=./server-icon.png'
	[survival]='-Xmx3G -Xms2G -Xdock:name="Survival_Server" -DGeyserSkinManager.ForceShowSkins=true -Xdock:icon=./server-icon.png'
	[ctl]='-Xms2G -Xmx3G -Xdock:name=CTL -DGeyserSkinManager.ForceShowSkins=true -Xdock:icon=./server-icon.png'
	#[jack]='-Xms2G -Xmx3G -Xdock:name="Jacks_Server" -DGeyserSkinManager.ForceShowSkins=true -Xdock:icon=./server-icon.png'
	[fabric]='-Xmx5G -Xms4G -Xdock:name=Fabric_Server -Xdock:icon=./server-icon.png'
	)
declare -A OPTS=(
	[lobby]="--server-name Lobby -h 127.0.0.1 -o false --log-pattern lobby.log -W ../universe/lobby -c ../properties/lobby.properties --log-pattern ../logs/lobby/$DATE.log "
	[survival]="--server-name Survival -h $HOST -o $ --log-pattern survival.log -W ../universe/survival -c ../properties/survival.properties --log-pattern ../logs/survival/$DATE.log"
	[ctl]=" --server-name CTL -h $HOST -o $ONLINE --log-pattern ctl.log -W ../universe/ctl -c ../properties/ctl.properties --log-pattern ../logs/ctl/$DATE.log "
	#[jack]="--server-name Jack's Server -h $HOST -o $ONLINE --log-pattern jack.log -W ../universe/jack -c ../properties/jack.properties --log-pattern ../logs/jack/$DATE.log "
	[fabric]='--universe ../universe/fabric'
	)
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
TIME="$(date +%Y-%d-%m_%H-%M)"
AIKAR='-XX:+UseG1GC -XX:+ParallelRefProcEnabled -XX:MaxGCPauseMillis=200 -XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:+AlwaysPreTouch -XX:G1HeapWastePercent=5 -XX:G1MixedGCCountTarget=4 -XX:G1MixedGCLiveThresholdPercent=90 -XX:G1RSetUpdatingPauseTimePercent=5 -XX:SurvivorRatio=32 -XX:+PerfDisableSharedMem -XX:MaxTenuringThreshold=1 -XX:G1NewSizePercent=30 -XX:G1MaxNewSizePercent=40 -XX:G1HeapRegionSize=8M -XX:G1ReservePercent=20 -XX:InitiatingHeapOccupancyPercent=15 -Dusing.aikars.flags=https://mcflags.emc.gs -Daikars.new.flags=true'
ZGC="-XX:+UnlockExperimentalVMOptions -XX:+DisableExplicitGC -XX:-UseParallelGC -XX:-UseParallelOldGC -XX:-UseG1GC -XX:+UseZGC -Xlog:gc*:logs/ZGC/$TIME.log:time,uptime:filecount=2,filesize=8M"
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
			;;
		*)
			warn "$1 is not a valid server and will be ignored."
			;;
	esac
	shift
done
echo -e "Starting the following servers: \n${SERVERS[*]}\n"
if [[ -z $VELOCITY ]]
then
	VELOCITY=false
fi
## Backup
cd ~/Minecraft
if [[ $BACKUP = true ]]
then
	pushd ./backup
	for SERVER in ${SERVERS[*]}
	do
		pushd $SERVER
		#OLDZIPS=$(find . -type f | head -n 10 )
		#diff -q $OLDZIPS $(find . -type f )
		tar -czf ./$SERVER/"$TIME".tar.gz ../universe/$SERVER
		popd
	done
	popd
fi
## Starting of server
line(){
	echo $1
}
set -x
if ! tmux has -t 'SERVERS' 2>/dev/null
then
	line 128
  tmux new -ds SERVERS -n "${SERVERS[0]}" -c "$MC_DIR"
fi
line 134
for WINDOW in ${SERVERS[*]}
do
  if tmux findw -t "$WINDOW" 2>/dev/null
  then
		tmux send -t "$WINDOW" 'stop
		'
		line 138
		until ! tmux findw -t "$WINDOW" 2>/dev/null
		do
			sleep 3
		done
  fi
	tmux neww -t SERVERS -c "$MC_DIR" -n "$WINDOW"
	line 145
  tmux send -t "$WINDOW" "java -version && echo $WINDOW && read STOP && exit
	"
	#if tmux findw -t 'bash'
	#then
	#	tmux killw -t 'bash'
	#fi
done
echo 'All done!'
