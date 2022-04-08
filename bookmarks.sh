#!/usr/bin/env bash
BROWSER='Brave Browser'
case "$#" in
0)
  BOOKMARKS=~/Desktop/Bookmarks
  ;;
*)
  BOOKMARKS="$1"
  ;;
esac
LIST=$(find "$BOOKMARKS" -maxdepth 1 |tr '\n' ' ')
for x in "$LIST"
do
  open $x -a "$BROWSER"
done
