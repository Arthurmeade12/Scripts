#!/usr/local/Cellar/bash/5.1.8/bin/bash
. ~/bashrc/is_env_sane.sh
prompt(){
	echo -ne "${BLUE}${BOLD}==>${RESET} ${WHITE}$@${RESET}"
}
no_path(){
	echo "$(tput setaf 1)Path does not exist.$(tput sgr0)"
	if test $a -eq 5
	then
		echo "5 invalid paths. Using default ones."
	else
		unset DIR
		prompt 'What path ? '
		continue
	fi
}
if [[ $1 = 'client' ]]|| [[ $1 = 'server' ]]
then
	ENV=$1
else
	test $1 && out "Invalid 1st argument, (not client or server) $1; ignoring it"
	test $ENV && unset ENV
fi
LATEST_INST=0
JAR='https://maven.quiltmc.org/repository/release/org/quiltmc/quilt-installer/latest/quilt-installer-latest.jar'
out "Welcome to Arthur's Quilt installer!" 'Downloading installer ...'

curl $JAR -o /tmp/quilt-installer.jar
### Env choice
if [[ -z $ENV ]]
then
	prompt "Would you like to install for a server, or for the normal game (client) ? $(tput setaf 2)(server|client)"
	while a=$((a + 1)); do
		read -t 20 ENV
		test $? -gt 128 && echo -e "\nNo answer in 20 seconds - exiting" && exit 128
		echo
		case $ENV in
		client)
			ARGS='client'
			;;
		server)
			ARGS='server'
			;;
		*)
			echo "$(tput setaf 1)Invalid answer."
			test $a -eq 5 && abort '5 invalid answers.'
			prompt '(server|client)'
			continue
			;;
		esac
		readonly ENV
		break
	done
else
	out "Detected your environment as $1."
fi
### Dir choice
prompt "Would you like to install to a specific folder ? Leave blank to install to defaults. (client: ~/Library/Application Support/minecraft server: current folder which is $PWD) : "
while a=$((a + 1)); do
	read -t 30 DIR
	echo
	case $DIR in
	?*)
		if [[ $DIR != /* ]] || [[ $DIR != */ ]] || [[ $DIR != */* ]]
		then
			echo 'first trap'
			no_path
		elif [[ ! -d $DIR ]]; then
			mkdir $DIR
			ARGS="$ARGS -downloadMinecraft"
		elif [[ $DIR = '~' ]]; then
			ARGS="$ARGS -dir $HOME"
		elif [[ ! -r $DIR  ]] || [[ ! -w $DIR ]]; then
			no_path
		else
			true
		fi
		out "Using path $DIR."
		readonly DIR
		;;
	*)
		out "Using default paths."
		;;
	esac
	case $DIR in
	client)
		DIR='~/Library/Application\ Support/minecraft' &>/dev/null
		[ $? -ne 0 ] && ARGS="$ARGS -dir $DIR"
		;;
	server)
		DIR="$(pwd)" &>/dev/null
		[ $? -ne 0 ] && ARGS="$ARGS -dir $DIR"
		;;
	esac
	break
done
case $DIR in
	client)
		declare DIR='~/Library/Application\ Support/minecraft' 2>/dev/null
		[[ $? -ne 0 ]] && ARGS="$ARGS -dir $DIR"
		;;
	server)
		declare DIR='~/Desktop/minecraft_server' 2>/dev/null
		[[ $? -ne 0 ]] && ARGS="$ARGS -dir $DIR"
		;;
esac
### Loader version choice
out "Would you like a specific loader version ? If you don't know what this is, answer latest." "Possible answers: $(tput setaf 2)(wanted version), latest"
while a=$((a ++)); do
	prompt "What version?"
	read -t 30 VER
	test $? -gt 128 && echo -e "\nNo answer in 30 seconds - exiting" && exit 128
	echo
	case $VER in
	latest)
		out "Using latest version."
		;;
	0.*)
		#out "Outdated versions: 0.1.0.48 - 52, 0.2.0.53 - 71, 0.3.0.72 - 77, 0.3.1.80 - 82, 0.3.1.84 & 85, 0.3.2.86 & 87, 0.3.2.90 - 96, 0.3.3.97 - 102, 0.3.4.103 - 105, 0.3.5.106, 0.3.6.107 0.3.7.108 - 111, 0.4.0+build.112 - 121, 0.4.1+build.122 - 129, 0.4.2+build.130 - 132, 0.4.3+build.133 - 135, 0.4.4+build.136 - 139, 0.4.5+build.140, 0.4.6+build.141 - 145, 0.4.7+build.146 - 148, 0.4.7+build.152 & 153, 0.4.8+build.154 - 159, 0.4.9+build.160 & 161, 0.5.0+build.162, 0.6.0+build.163, 0.6.1+build.164 & 165, 0.6.2+build.166, 0.6.3+build.167 & 168, 0.6.4+build.169 & 170, 0.7.0+build.171 & 172, 0.7.1+build.173, 0.7.2+build 174 & 175, 0.7.3+build.176, 0.7.4+build.177, 0.7.5+build.178, 0.7.6+build.179 - 181, 0.7.7+build.182 & 183, 0.7.8+build.184 - 189, 0.7.9+build.190, 0.7.10+build.191, 0.8.0+build.192, 0.8.1+build.193, 0.8.2+build.194, 0.8.3+build.196, 0.8.4+build.198, 0.8.5+build.199, 0.8.6+build.200, 0.8.7+build.201, 0.8.8+build.202. 0.8.9+build.203, 0.9.0+build.204, 0.9.1+build.205, 0.9.2+build.206, 0.9.3+build.207, 0.10.0+build.208, 0.10.1+build.209, 0.10.2+build.210, 0.10.3+build.211, 0.10.4+build.212, 0.10.5+build.213, 0.10.6+build.214, 0.10.7 & 8, 0.11.0 - 6, 0.12.0 & 1 (whew! that's a lot)"
		out "Using version $VER."
		;;
	*)
		echo "$(tput setaf 1)Invalid answer."
		test $a -eq 5 && abort '5 invalid answers.'
		prompt '(server|client)'
		continue
		;;
	esac
	# Weak detection methods
	TMP=$(echo $VER | tr -d '+build')
	# I'm to lazy to put in version checking for answers
	if ! (echo $TMP | grep '0.'); then
		echo "$(tput setaf 1)Invalid version.$(tput sgr0)"
		if test $a -eq 5
		then
			echo "5 invalid versions. Using latest."
			VER=latest
		else
			continue
		fi
	elif (echo $TMP | grep {a..z}); then
		echo "$(tput setaf 1)Invalid version.$(tput sgr0)"
		if test $a -eq 5
		then
			echo "5 invalid versions. Using latest."
			VER=latest
		else
			continue
		fi
	else
		# passed first check
		:
	fi
	case $TMP in
	0.?.?.??|0.?.?.1??|0.?.?.2??|0.7.10.191|0.10.?.2??|0.1?.?)
		out "Detected version as $VER."
		;;
	*)
		echo "$(tput setaf 1)Invalid version.$(tput sgr0)"
		if test $a -eq 5
		then
			echo "5 invalid versions. Using latest."
			VER=latest
		else
			continue
		fi
		;;
	esac
	readonly VER
	unset TMP
	break
done
ARGS="$ARGS -loader $VER"
echo
java -jar /tmp/quilt-installer.jar $ARGS
STATUS=$?
case $STATUS in
0)
	out "The installation appeared to have succeeded!"
	;;
1)
	out "$(tput setaf 2)Failed installation.$(tput sgr0)"
	;;
esac
exit $?
