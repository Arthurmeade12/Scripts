#!/usr/bin/env bash
set -B
### Colors
RED=$(tput setaf 1)
BLUE=$(tput setaf 20)
BOLD=$(tput bold)
WHITE=$(tput setaf 15)
MAGENTA=$(tput setaf 5)
RESET=$(tput sgr0)
YELLOW=$(tput setaf 3)
GREEN=$(tput setaf 2)
### Other Vars
TIMEOUT=60
export TIMEOUT
### Functions
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
warn(){
	for X in "$@"; do
		echo -en "${RED}${BOLD}==>${RESET} ${YELLOW}WARNING: ${X} "
		echo "$RESET"
	done
}
boolean(){
	local PROMPT=$1 VAR=$2 OPTS=$3 POSSIBLE=false a=0
	ANSWER=''
	shift 4
	while a=$((a + 1))
	do
		read -rp "${GREEN}${BOLD}==>${RESET} $WHITE$PROMPT (y|n) " "${OPTS?}" ANSWER
		echo
		case $ANSWER in
			[Yy]|[Nn])
				# shellcheck disable=SC2034
				POSSIBLE=true
				break
				;;
			*)
				out "${RED}Invalid answer."
				case $a in
				5)
					abort "5 invalid answers."
					;;
				*)
					true
					;;
				esac
		esac
	done
	export ANSWER
}
### OS checks
# MacOS (really Darwin) check
case "$(sysctl -n kern.ostype)" in
Darwin )
	true
	;;
* )
	warn ": You are not running MacOS."
	;;
esac
# 64-bit compat check
case "$(sysctl -n hw.cpu64bit_capable)" in
1 ) :
	;;
* ) warn "Your OS is not 64-bit compatible."
	;;
esac
# Intel processor check
case "$(sysctl -n machdep.cpu.brand_string | grep Intel)" in
	Intel* ): ;;
	* )	warn "You are not using the Intel processor. Maybe you are running Arm or PowerPC."
	;;
esac
### Body of script
out "This script will install MultiMC on your machine."
out "For more information, please visit https://multimc.org."
boolean 'Would you like to continue ?' 'DO' '-n 1'
out "Your answer was: $ANSWER"
