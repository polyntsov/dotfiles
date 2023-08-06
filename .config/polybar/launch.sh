#!/usr/bin/env bash

# Terminate already running bar instances
# If all your bars have ipc enabled, you can use 
polybar-msg cmd quit
# Otherwise you can use the nuclear option:
# killall -q polybar

for m in $(polybar --list-monitors | cut -d":" -f1); do
    MONITOR=$m polybar --reload bar 2>/tmp/polybarlog & disown
    #echo "---" | tee -a /tmp/polybar1.log
    #polybar bar 2>&1 | tee -a /tmp/polybar1.log & disown
done

