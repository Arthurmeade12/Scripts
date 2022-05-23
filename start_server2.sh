#!/usr/bin/env bash
set -euBo pipefail
### Settings
CONFIG=~/Minecraft/config.sh
#shellcheck source=~/Minecraft/config.sh
source $CONFIG
export TIMEOUT
RED=$(tput setaf 1)
BLUE=$(tput setaf 20)
BOLD=$(tput bold)
WHITE=$(tput setaf 15)
MAGENTA=$(tput setaf 5)
RESET=$(tput sgr0)
#shellcheck disable=SC2034
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
SERVERS=()
if [[ $ITERM = true ]]
then
	ITERM='-CC'
else
	unset ITERM
fi
#shellcheck disable=SC2034
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
	#shellcheck disable=SC2048 disable=SC2086
  read -rp "$GREEN$BOLD==>$RESET $WHITE Which server(s) do you want to start? (lobby|survival|ctl|quilt|velocity) " -a SERVERS
	if [[ $? -eq 142 ]]
	then
		abort "No activity for 1 minute."
	fi
	#shellcheck disable=SC2048 disable=SC2086
	set ${SERVERS[*]}
	SERVERS=()
fi
until [[ $# -eq 0 ]]
do
	case "$1" in
		lobby|survival|ctl|quilt)
			SERVERS+=("$1")
			;;
		velocity)
			SERVERS+=(velocity)
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
# Ready
pushd "$MC_DIR"
if [[ $BACKUP = 'true' ]]
then
	pushd ./backup
	#shellcheck disable=SC2048
	for SERVER in ${SERVERS[*]}
	do
		tar -czpkf ./"$SERVER"/"$TIME".tar.gz ../universe/"$SERVER"
    # -p, preserve permissions, -k, do not overwrite an existing file, new one every hour with $TIME
    rm "$(/bin/ls -t1 | tail -1)" # always remove oldest copy, aka always have 10 copies
	done
	popd
fi
if [[ $UPDATE_PURPUR = 'true' ]]
then
	echo 'Updating Purpur ...'
	mv -f ./purpur-1.??.?-????.jar ./.old-jars/old-purpur.jar
	trap 'echo "Interrupt" && mv ./.old-jars/old-purpur.jar ./purpur.jar' 1 2 3 6
	curl -JLO# https://api.pl3x.net/v2/purpur/1.18.2/latest/download
	CURL=$?
	trap -
	case "$CURL" in
	0)
		echo 'Done.'
		;;
	*)
		echo 'Failed, please manually download jar from https://purpurmc.org/downloads'
		cp "$OLD_JAR" ./old-purpur.jar
		exit 1
		;;
	esac
fi
## Starting of server
set -x
trap 'tmux detach && echo "Interrupt" && exit 1' 1 2 3 6
if tmux has -t SERVERS 2>/dev/null
then
  echo 'Session already exists! Attaching ..'
	tmux attach -t SERVERS
	exit $?
else
  tmux new-session -ds SERVERS
fi
#shellcheck disable=SC2048
for Z in ${SERVERS[*]}
do
	case "$Z" in
	velocity)
		pushd ./velocity
		reset(){
			echo 'false' > ./.velocity_stat
		}
		if grep 'true' < ./.velocity_stat 1>/dev/null
		then
			echo "$(tput setaf 1)Error: Velocity is already started."
			continue
		fi
		echo 'true' > ./.velocity_stat
		tmux neww -t SERVERS -c "$MC_DIR/velocity" -n "${Z^}" "caffeinate -ims sudo nice -n -5 /usr/libexec/java_home -v $JAVA_VERSION --exec java $ZGC ${CUSTOMJAVAOPTIONS[velocity]} -jar ../velocity-*.jar ${OPTS[velocity]}"
		echo 'false' > ./.velocity_stat
		popd
		;;
	quilt)
		if [[ $AUTOSERVERSYNC = 'true' ]]
		then
			echo 'Starting ServerSync ...'
			tmux neww -t "$SESSION" -n ServerSync -c "$MC_DIR"/quilt "java --module-path $JAVAFX --add-modules javafx.controls -jar serversync-4.2.0.jar -sp $SERVERSYNCPORT"
		fi
		tmux neww -t "$SESSION" -c "$MC_DIR"/"$Z" -n "${Z^}" "caffeinate -ims sudo nice -n -5 '/usr/libexec/java_home -v $JAVA_VERSION --exec java $ZGC ${CUSTOMJAVAOPTIONS[quilt]} -jar ../quilt-server-launch.jar --nogui ${OPTS[quilt]}'"
		;;
	survival|ctl|lobby)
		tmux neww -t "$SESSION" -c "$MC_DIR"/"$Z" -n "${Z^}" "caffeinate -ims sudo nice -n -5 '/usr/libexec/java_home -v $JAVA_VERSION --exec java $ZGC ${CUSTOMJAVAOPTIONS[$Z]} -jar ../purpur-*.jar --nogui ${OPTS[$Z]}'"
		;;
	esac
done
popd
tmux killw -t SERVERS:0
tmux $ITERM attach -t SERVERS
exit 0
