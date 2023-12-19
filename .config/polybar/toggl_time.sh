#!/bin/zsh

function work_time () {
    time=$(toggl sum -t 2>/dev/null)
    ret_code=$?

    if [ $ret_code -ne 0 ]; then
        return
    fi

    time=$(echo "$time" | grep today | awk -F' ' '{print $2}' | awk -F':' '{print $1":"$2}')
    if [ -z "$time" ]; then
        time="0:00"
    fi
    echo "$time hrs"
}

work_time
