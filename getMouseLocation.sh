#!/usr/bin/env bash

# edit to your screen real resolution:
WIDTH=1920
HEIGHT=1080

x=$((WIDTH / 2))
y=$((HEIGHT / 2))

libinput debug-events |
  awk -v x="$x" -v y="$y" -v w="$WIDTH" -v h="$HEIGHT" '
/POINTER_MOTION/ {
    if (match($0, /\([[:space:]]*[+-]?[0-9.]+\/[[:space:]]*[+-]?[0-9.]+\)/)) {
        s = substr($0, RSTART+1, RLENGTH-2)
        gsub(/[[:space:]]/, "", s)
        split(s, a, "/")

        x += a[1]
        y += a[2]

        if (x < 0) x = 0
        if (y < 0) y = 0
        if (x > w-1) x = w-1
        if (y > h-1) y = h-1

        printf "X=%4d Y=%4d\n", x, y
        fflush()
    }
}'
