#!/usr/bin/env bash
debug(){
	if test $DEBUG = 'true'; then
		echo "DEBUG: $1"
		local STAT=$?
	fi
	exit $STAT
	
}
set_debug(){
	DEBUG=true
	debug 'Debug messages turned on.'
}
err(){
	echo "ERROR: $1"
	exit $2
}
while a=$((a + 1)); do
	if [[ $# -ge 3 ]]; then
		echo 'ERROR: Detected extra arguments, ignoring them'
		until test $# -eq 2; do
			shift
		done
		a=$((a - 1))
		continue
	fi
	case $# in
	0)
		test a = 1 && URL='https://google.com'
		break
		;;
	*)
		case $1 in
		-d|--debug)
			set_debug
			shift
			continue
			;;
		http://*|https://*)
			URL=$1
			shift
			continue
			;;
		*)
			err 'Invalid URL / URL does not begin with http:// or https://' '2'
			;;
		esac
		;;
	esac
done
curl $URL -so /tmp/google.html 2>/dev/null
STAT=$?
case $STAT in
0)
	echo 'Connected to the internet'
	;;
*)
	echo 'Not connected to the internet'
	;;
esac
exit $STAT