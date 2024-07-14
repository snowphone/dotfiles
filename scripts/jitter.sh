#!/bin/sh

rand=$(od -An -N2 -i /dev/urandom | awk '{print $1%300}')

logger "$(printf "Jitter %d seconds" "$rand")"

sleep "$rand"
