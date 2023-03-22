#!/usr/bin/env bash
set -euo pipefail
### Make sure we're running bash, ksh, or zsh before we continue.
case "$(basename "${SHELL}")" in
bash)
	:
	;;
*)
	echo "ERROR: This script must be run with bash."
	exit
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
		echo -e "${BLUE}${BOLD}==>${RESET} ${BOLD}${X} "
	done
}
warn(){
	for X in "$@"; do
		echo -e "${YELLOW}${BOLD}==>${RESET} ${BOLD}WARNING: ${YELLOW}${X} ${RESET}"
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
### Bash checks
case "$BASH_VERSION" in
5.?.?*|4.?.?* )
	:
	;;
3.?.?* )
	: ## Suppressing because trinity computers use bash 3.
	;;
2.?.?*|1.?.?* )
	warn 'Your bash version is extremely outdated. To run this script, preferably use bash version ≥ 4.0.0, but only ≥ 3.0.0 is required.'
	exit 1
	;;
* )
	abort "Invalid bash version found in \$BASH_VERSION. Are you running bash ? Make sure your environment variables have been set correctly, and that you haven't put a fake bash executable in your PATH."
	;;
esac
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
	* )	warn "WARNING: You are not using the Intel processor. Hopefully you are running M1."
	;;
esac

### Real Script
if ! which brew &>/dev/null
then
  # Need homebrew
	out "Homebrew not found! Installing homebrew ...\n"
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	out "Great! Homebrew is installed!"
else
	out "Homebrew is already installed!"
fi
if ! (brew ls --formulae | grep 'python@3' 1>/dev/null)
then
	out "Python not found! Installing ..."
	brew install python@3.10
	out "Done."
else
	out "Python already installed!"
fi
out "The Python install is finished. To enter the python shell, run \`python3\`"
out "Bye!"
exit 0
