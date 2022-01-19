#!/usr/bin/env bash
MC_DIR=~/Minecraft
UNIVERSE=$MC_DIR/universe
BACKUP=$MC_DIR/backup
cd $UNIVERSE
ARGS=-dbrST
for Z in $@
do
  cd $Z
  if [[ -f $OLD_ZIP ]]
  then
    ARGS+=f
  fi
  zip $ARGS $(date "+%Y-%d-%m %H:%M")                                                     
done
