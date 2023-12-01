#!/usr/bin/env bash
cd ~/Minecraft
if getopts s SERVER
then
  java --module-path $JAVAFX --add-modules javafx.controls -jar serversync-4.2.0.jar -sp 25598 -r ./quilt
  exit $?
else
  case $(hostname) in
  Arthur-Meade|manjaro)
    java --module-path $JAVAFX --add-modules javafx.controls -jar serversync-4.2.0.jar -r ~/Library/Application\ Support/PolyMC/instances/Quilt\ Server/.minecraft
    ;;
  *)
    echo 'Where did you get this script?'
    ;;
  esac
fi
