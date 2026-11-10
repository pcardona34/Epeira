#!/bin/bash

### Inspired by https://surf.suckless.org/files/bmarks/

file=~/.surf/bookmarks
WINDOW_ID=$(xdotool search --onlyvisible --class surf)
echo "WINDOW ID: ${WINDOW_ID}"
if  [ -n "$WINDOW_ID" ];then
	url=`xprop -id ${WINDOW_ID} | grep URI | awk '{print $3}' | sed 's/\"//g'`
   echo ${url} > $file
fi
