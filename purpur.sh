#!/usr/bin/env bash
source ~/bashrc/is_env_sane.sh
TARGET_DIR=~/Downloads
URL=https://api.pl3x.net/v2/purpur/1.18.2/latest/download
cd $TARGET_DIR || (echo "$(tput setaf 1)Folder is not writable!$(tput sgr0)" && exit 1)
curl -JLO# ${URL} ./purpur-1.17.1.jar
exit
