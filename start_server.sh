#!/usr/bin/env bash
set -Bo pipefail
### Settings
CONFIG=~/Minecraft/config.sh
#shellcheck source=~/Minecraft/config.sh
. $CONFIG
. ~/Minecraft/env.sh
update(){
	pushd "$MC_DIR"
	out "Updating ${1^} ..."
	mv -f ./$2 ./.old-jars/old-${1}.jar
	if [[ $? -ne 0 ]]
	then
		warn 'You are already using a backup jar. Please update manually.'
	else
		trap "echo 'Interrupt' && mv ./.old-jars/old-${1}.jar ./${1}-backup.jar" 1 2 3 6
		curl -JLO# $3
		CURL=$?
		trap
		case "$CURL" in
		0)
			out 'Done.'
			;;
		*)
			out 'Failed, installing backup.'
			cp "$OLD_JAR" ./${1}-old.jar
			;;
		esac
	fi
	popd
}
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
	if grep 'true' < $STATUSDIR/${1}.txt 1>/dev/null
	then
		out "${RED}Error: ${1^} is already started.${RESET}"
		return 1
	else
		echo 'true' > $STATUSDIR/${1}.txt
	fi
}
if [[ $# = 0 ]]
then
	#shellcheck disable=SC2048 disable=SC2086
  read -rp "$GREEN$BOLD==>$RESET $WHITE Which server(s) do you want to start? (Lobby|Survival|Ctl|Quilt|Velocity|ServerSync) " -a SERVERS
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
		lobby|survival|ctl|quilt|velocity|serversync)
			SERVERS+=("$1")
			;;
		*)
			warn "$1 is not a valid server and will be ignored."
			;;
	esac
	shift
done
out "Starting the following servers: \n${SERVERS[*]}\n"
## Backup
# Ready
pushd "$MC_DIR"
if [[ $BACKUP = 'true' ]]
then
	pushd ./backup
	#shellcheck disable=SC2048
	for SERVER in ${SERVERS[*]}
	do
		[[ $SERVER = 'velocity' ]] && continue
		[[ $SERVER = 'quilt' ]] && continue
		pushd ./$SERVER
		tar -czpkf ./"$TIME".tar.gz ../../universe/$SERVER &
    # -p, preserve permissions, -k, do not overwrite an existing file, new one every hour with $TIME
    #rm "$(ls -t1 | head -n 10)" # always remove oldest copy, aka always have 10 copies
		popd
	done
	popd
fi
## Starting of server
trap 'tmux detach && echo "Interrupt" && exit 1' 1 2 3 6
if tmux has -t SERVERS 2>/dev/null
then
  KILLW=false
else
	KILLW=true
  tmux new-session -ds SERVERS
fi
#shellcheck disable=SC2048
for Z in ${SERVERS[*]}
do
	server_running $Z || continue
	case $Z in
	velocity)
		if [[ $UPDATE_VELOCITY = 'true' ]]
		then
			update 'velocity' 'velocity-?.?.?-SNAPSHOT-???.jar' 'https://chew.pw/mc/jars/velocity'
		else
			out 'Skipping updates for Velocity.'
		fi
		tmux neww -t SERVERS -c "$MC_DIR/velocity" -n "${Z^}" "caffeinate -ims bash -c 'exec -a ${Z^}_Server /usr/libexec/java_home -v $PREFERRED_JAVA --exec java $ZGC ${CUSTOMJAVAOPTIONS[velocity]} -jar ./velocity-*.jar ${OPTS[velocity]}'"
		;;
	quilt)
		if [[ $AUTOSERVERSYNC = 'true' ]]
		then
			SERVERS+=(serversync)
		fi
		tmux neww -t "$SESSION" -c "$MC_DIR"/"$Z" -n "${Z^}" "caffeinate -ims bash -c 'exec -a ${Z^}_Server /usr/libexec/java_home -v $PREFERRED_JAVA --exec java $ZGC ${CUSTOMJAVAOPTIONS[quilt]} -jar ./quilt-server-launch.jar --nogui ${OPTS[quilt]}'"
		;;
	serversync)
		out 'Starting ServerSync ...'
		tmux neww -t "$SESSION" -n ServerSync -c "$MC_DIR"/quilt "bash -c 'exec -a ServerSync /usr/libexec/java_home -v $PREFERRED_JAVA java --module-path $JAVAFX --add-modules javafx.controls -jar serversync-4.2.0.jar -sp $SERVERSYNCPORT'"
		;;
	survival|ctl|lobby)
		if [[ $UPDATE_PURPUR = 'true' ]]
		then
			update 'purpur' 'purpur-1.??.?-????.jar' 'https://api.purpurmc.org/v2/purpur/1.18.2/latest/download'
		else
			out 'Skipping updates for Purpur.'
		fi
		tmux neww -t "$SESSION" -c "$MC_DIR"/"$Z" -n "${Z^}" "caffeinate -ims bash -c 'exec -a ${Z^}_Server /usr/libexec/java_home -v $PREFERRED_JAVA --exec java $ZGC ${CUSTOMJAVAOPTIONS[$Z]} -jar ../purpur-*.jar --nogui $PURPUR_OPTS ${OPTS[$Z]}'"
		;;
	esac
 	out "Started server ${Z^}!"
done
popd
if [[ $KILLW = 'true' ]]
then
	tmux killw -t SERVERS:0
fi
exit 0
