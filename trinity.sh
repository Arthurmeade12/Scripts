#!/bin/bash
tput sgr0
PEOPLE=(Camille Arthur Laine Baldwin Collins)
for x in ${PEOPLE[*]}; do
	echo "Hey $(tput bold && tput setaf 4) $x!$(tput sgr0)"
	sleep 0.5
	echo
done