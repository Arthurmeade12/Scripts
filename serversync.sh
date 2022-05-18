#!/usr/bin/env bash
cd ~/Minecraft
java --module-path $JAVAFX --add-modules javafx.controls -jar serversync-4.2.0.jar $@
exit $?
