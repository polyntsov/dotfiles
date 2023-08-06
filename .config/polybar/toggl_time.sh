#!/bin/zsh

function work_time () {
    time=$(toggl sum -t | grep today | awk -F' ' '{print $2}' | awk -F':' '{print $1":"$2}')
    echo "$time"
}

work_time
