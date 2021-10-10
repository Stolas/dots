#!/usr/bin/bash

function move_to_workspace () {
    for pid in `pidof $1`; do
        wmctrl -ir $(wmctrl -l -p | grep $pid | sort -r | head -1 | awk '{print $1;}') -t $(wmctrl -d | grep $2 | cut -d " " -f 1 | head -n 1);
    done
}


while [ true ]; do
    move_to_workspace 'firefox' 'Browser'
    move_to_workspace 'spotify' 'Media'
sleep 1;
done
