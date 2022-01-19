#!/bin/bash
set -e
arch_msg(){
	echo -e "${@}: /Applications/Google Chrome.app.zip & ~/Library/Application\ Support/Google.zip."
}
cd /tmp
unzip /Applications/Google\ Chrome.app.zip
mv -i ./Google\ Chrome.app /Applications/Google\ Chrome.app
unzip ~/Library/Application\ Support/Google.zip
mv -i ./Google ~/Library/Application\ Support/Google
rm -r ./__MACOSX
read -p 'Delete archives ? (y/n) ' -t 10 -n 1 RM
if [[ $? -gt 128 ]]; then arch_msg '\n10 second time limit expired. Exiting & leaving archives' ;exit 0;fi
echo
case $RM in
y)
	arch_msg 'Deleting archives'
	rm ${ARCHIVES[*]}
	;;
n)
	arch_msg 'Not delting archives'
	;;
?*)
	arch_msg 'Invalid answer. Not deleting archives'
	;;
esac
cd ~
exit 0
