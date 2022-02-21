#!/usr/bin/env bash
BROWSER='Brave Broswser Beta'
case "$#" in
0)
  BOOKMARKS=~/Desktop/Bookmarks
  ;;
*)
  BOOKMARKS="$1"
  ;;
esac
for x in {$(find "$BOOKMARKS" -maxdepth 1)}
do
  open $x -a "$BROWSER"
done
