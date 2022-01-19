#!/usr/bin/env bash
out(){
	for X in "$@"; do
		echo -e "$(tput setaf 20 && tput bold)==>$(tput setaf 15) ${X} $(tput sgr0)"
	done
}
num(){
	out "$(tput setaf 10)Question #${1}:"
}
question(){
	while true; do
		PS3="$1"
		select $ in $3
		do
			PS3="Are you sure? "
			select SURE in {yes,no}
			do
				case $SURE in
				yes)
					out "Saved answer for question 1 as $(eval $(echo \$${2})). Now unchangeable."
					readonly $2
					break 3
					;;
				no)
					:
					;;
				*)
					out "Invalid answer, assuming you're unsure."
					;;
				esac
				out "Try again!\n"
				break 2
			done
		done
		continue
	done
}
question "What is the capital od Azerbaijan?" AZERBAIJAN "{Baku,T\'blisi,Yerevan,Sevastopol}"
exit
###
num 1
while true; do
	PS3='What is the capital of Azerbaijan? '
	select AZERBAIJAN in {Baku,T\'blisi,Yerevan,Sevastopol}
	do
		PS3="Are you sure? "
		select SURE in {yes,no}
		do
			case $SURE in
			yes)
				out "Saved answer for question 1 as $AZERBAIJAN. Now unchangeable."
				readonly AZERBAIJAN
				break 3
				;;
			no)
				:
				;;
			*)
				out "Invalid answer, assuming you're unsure."
				;;
			esac
			out "Try again!\n"
			break 2
		done
	done
	continue
done
echo "Answer was: Baku"
exit