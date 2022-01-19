#!/usr/bin/env bash
set -B
RED=$(tput setaf 1)
BLUE=$(tput setaf 20)
BOLD=$(tput bold)
WHITE=$(tput setaf 15)
MAGENTA=$(tput setaf 5)
RESET=$(tput sgr0)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
MC_DIR=~/Minecraft
SERVERS=()
TIMEOUT=60
export TIMEOUT
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
backup ${SERVERS[*]}
update_purpur
popd
