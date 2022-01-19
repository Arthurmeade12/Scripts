#!/usr/bin/env bash
set -ebhmBo pipefail --
PASSWORD=change # true|false|change
TIMEOUT=60
HASH_PATH=~/hash.txt
export PASSWORD{,_PATH} TIMEOUT HASH_PATH
ask_sensitively(){
	PROMPT=$1
	VAR=$2
	shift 2
	# shellcheck disable=SC2229
	read -srp "$PROMPT" "$@" "$VAR"
	echo
}
ask(){

	read -rp "$1" "$2"
}
case $PASSWORD in
false)
	echo 'Skipping verification.'
	;;
true)
	if [[ -f $HASH_PATH ]]
	then
		while a=$((a + 1))
		do
			ask_sensitively 'Password:' PASS
			if [[ "$HASH" = "$OLD_HASH" ]]
			then
				echo 'Authenticated.'
				unset a PASS
				break
			else
				echo 'Wrong password.'
			fi
		done
	else
		echo -e "ERROR: The file containing the hash of your password does not exist.\nIf you deleted this file, you either need to create a password or choose not to have one.\nTo create a password, set the value of PASSWORD to 'create'. "
		exit 1
	fi
		;;
change|create)
	ask "Would you like to $PASSWORD a password ? (y/n) " 'CREATE_PASS' '-n 1'
	case $CREATE_PASS in
	[yYx])
		echo -e "\nGreat! To avoid being asked again, make sure PASSWORD is set to 'true' in your config file."
		while a=$((a + 1))
		do
			ask_sensitively 'Enter your new password:' PASS1
			ask_sensitively "Enter it again:" PASS2
			if [[ "$PASS1" = "$PASS2" ]]
			then
				unset PASS1 a
				break
			else
				case $a in
				5)
					echo -e '5th password mismatch. \nAborting ...'
					if [[ $PASSWORD = 'change' ]]
					then
						echo 'Restoring your old password ...'
					fi
					exit 1
					;;
				*)
					echo 'Password mismatch. You did not enter the same password twice.'
					;;
				esac
			fi
		done
		HASH=$(echo "$PASS2" | sha512sum)
		unset PASS2
		echo "$HASH" > "$HASH_PATH"
		echo 'Password set.'
		;;
	[nN])
		echo "Okay. To avoid being asked again, set PASSWORD to 'false' in your config."
		exit 0
		;;
	esac
	;;
esac
exit 0
