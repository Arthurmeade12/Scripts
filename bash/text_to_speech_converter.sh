#!/usr/bin/env bash
set -e
QUIET=false
FORMAT=0
VERBOSE=false
verbose(){
	[[ $VERBOSE ]] && bash -c $*
}
FILE=0
usage(){
	echo "Usage: ${0} [[ -qv ] [ -f file ... | -i ]] | [ -h ]" 
	echo "Run $0 -h for a help page"
	exit 2 
}
#### Experimental stuff
# Opt processing
OPTSTRING=hqif:v
while getopts $OPTSTRING ARGS; do
case $ARGS in
h ) echo 'Sorry, the help page has not been made yet.'
	usage
	exit 0 ;;
q ) QUIET=true ;;
i ) FORMAT=1 ;;
f ) FORMAT=2
	FILE=${OPTARG} ;;
v ) VERBOSE=true ;;
? ) echo "Error: invalid option" 1>/dev/stderr
	usage 1>/dev/stderr
esac
if [[ -z ${FILE} ]]; then
	usage 1>/dev/stderr
fi
break
done
readonly QUIET &> /dev/null
readonly FORMAT &> /dev/null
readonly VERBOSE &> /dev/null
readonly FILE &> /dev/null
for x in $*; do
	if [[ $FORMAT = 2 ]]; then
		cat $FILE | say -v 'fred' -i ${1}
	fi
	case $x in
	-? ) continue ;;
	* ) tput bold
		say -v 'fred' -i "$x"
		tput sgr0
		;;
	esac
done
echo -e "Var values: \n QUIET=${QUIET}\n FORMAT=${FORMAT}\n VERBOSE=${VERBOSE}\n FILE=${FILE}"
echo 'Done !'
exit 0
# Still a work in progress