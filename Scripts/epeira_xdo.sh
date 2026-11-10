#!/bin/bash

KEY=$1
if [ -n "${KEY}" ];then
	echo "Performing $0 with Key: ${KEY}..."
	WINDOW_ID=$(xdotool search --onlyvisible --class surf)
	echo "WINDOW ID: ${WINDOW_ID}"
	if [ -n "$WINDOW_ID" ];then
		xdotool windowfocus --sync ${WINDOW_ID} && xdotool key --clearmodifiers ctrl+${KEY}
		echo "$0 has been executed."
	fi
fi
