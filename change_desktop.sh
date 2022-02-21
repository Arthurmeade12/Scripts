#!/usr/bin/env bash
# change_desktop.sh
#############################################################################
# Copyright (©) 2021, Arthur Meade <arthurmeade12@gmail.com>
#
# This software is provided 'as-is', without any express or implied
# warranty. In no event will the authors be held liable for any damages
# arising from the use of this software.
#
# Permission is granted to anyone to use this software for any purpose,
# including commercial applications, and to alter it and redistribute it
# freely, subject to the following restrictions:
#
#  1. The origin of this software must not be misrepresented; you must not
#  claim that you wrote the original software. If you use this software
#  in a product, an acknowledgment in the product documentation is required.
#
#  2. Altered source versions must be plainly marked as such, and must not be
#  misrepresented as being the original software.
#
#  3. This notice may not be removed or altered from any source
#  distribution.
#############################################################################
set -euo pipefail
### Make sure we're running bash, ksh, or zsh before we continue.
case $BASH_VERSION in
5.?.?*|4.?.?* )
	:
	;;
3.?.?* )
	# tput setaf 3 && tput bold
	# echo -n 'WARNING:'
	# tput sgr0 && tput setaf 3
	# echo 'You are using an outdated version of bash. If possible, please use this script with Bash Version ≥ 4.0.0.'
	# tput sgr0
	## Suppressing because trinity computers use bash 3.
	true
	;;
2.?.?*|1.?.?* )
	tput setaf 1 && tput bold
	echo -n 'ERROR:'
	tput sgr0 && tput setaf 1
	echo 'Your bash version is extremely outdated. To run this script, preferably use bash version ≥ 4.0.0, but only ≥ 3.0.0 is required.'
	tput sgr0
	exit 1
	;;
?* )
	tput setaf 1 && tput bold
	echo -n 'ERROR:'
	tput sgr0 && tput setaf 1
	echo "Invalid bash version found in \$BASH_VERSION. Are you running bash ? Make sure your environment variables have been set correctly, and that you haven't put a fake bash executable in your \$PATH. "
	tput sgr0
	;;
* )
	tput setaf 1 && tput bold
	;;
esac
### Vars
SUDO=false
if [[ $EUID = 0 ]]; then
	SUDO=true
fi
BLUE=$(tput setaf 4)
BOLD=$(tput bold)
RESET=$(tput sgr0)
RED=$(tput setaf 1)
YELLOW=$(tput setaf 3)
UNDERLINED=$(tput smul)
# Readonly vars
for X in {BLUE,BOLD,RESET,RED,SUDO,UNDERLINED}; do
	readonly -- "$X"
done

### Functions
out(){
	for X in "$@"; do
		echo -en "${BLUE}${BOLD}==>${RESET} ${BOLD}${X} \n"
		tput sgr0
	done
}
abort(){
	[ $# -ne 1 ] && return 2
	echo -en "${RED}$*"
	echo
	exit 1
}
qq(){
	echo -en "${BLUE}${BOLD}==>${RESET} ${BOLD}${1} ${YELLOW}"
}
# Readonly funcs
for X in {out,abort,qq}; do
	readonly -f "$X"
done
### OS checks
# MacOS (really Darwin) check
case $(sysctl -n kern.ostype) in
Darwin ): ;;
* ) abort "ERROR: You are not running MacOS."
	;;
esac
# 64-bit compat check
case $(sysctl -n hw.cpu64bit_capable) in
1 ) :
	;;
* ) abort "ERROR: Your OS is not 64-bit compatible. \nAborting..."
	;;
esac
# Intel processor check
case $(sysctl -n machdep.cpu.brand_string | grep Intel) in
	Intel* ): ;;
	* )	echo -e "ERROR: You are not using the Intel processor. Maybe you are running Arm or PowerPC. \nAborting..."
	;;
esac
#if [[ ! -d /Library/TESNOLA ]]
#then
#	abort 'This computer is not being managed by the Trinity Episcopal School. '
#fi
### Introduction
out "Welcome to Arthur's Desktop changer!" "This script lets you change your desktop image to whatever you like, with a some exceptions."
out "$YELLOW${UNDERLINED}You cannot have different images for each desktop, they must all be the same."
out "You can use this script multiple times, and to change an image you changed before. "
qq "Would you like to continue? (y/n)"
a=0
while a=$((a + 1)); do
	echo "\$a = $a"
	read -rn 2 -t 30 CONSENT
	if [[ $? -eq 142 ]]
	then
		echo
		abort "30 seconds of inactivity. \nAborting ..."
	fi
	case $CONSENT in
	[Yy])
		out "Great!
		..."
		break
		;;
	[Nn])
		out "Just fine! Exiting ..."
		exit 0
		;;
	*)
		echo
		out "${RED}Invalid answer."
		if [[ $a -eq 5 ]]; then
			abort "5 invalid answers.\n Aborting ..."
		fi
		qq "Would you like to continue? (y/n)"
		;;
	esac
done
exit 0
cd /Library/TESNOLA
COMMAND='cp $INPUT /Library'
(
	COMMAND='mv ./TESNOLA.png /tmp/old_TESNOLA.png'
	case "$SUDO" in
	true)
		"$COMMAND"
		;;
	false)
		out "Asking for your password to change image:"
		sudo $COMMAND
)
ln -s
