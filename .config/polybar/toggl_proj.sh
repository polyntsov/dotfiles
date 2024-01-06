#!/bin/zsh

function current_task () {
    task=$(toggl ls -f 'project, description, stop' 2>/dev/null)
    ret_code=$?

    if [ $ret_code -ne 0 ]; then
        return
    fi

    task=$(echo "$task" | grep running | \
        awk -F' \\(#|\\)  |  ' '{project=$1; $1=""; $2=""; sub(/^[ \t]+/, "", $0); print project ": " substr($0, 0, length($0)-length($NF)-1)}' | \
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    if [ -z "$task" ]; then
        echo "Doing nothing; the ethical life is the productive life (c)"
    else
        echo "$task"
    fi
}

current_task
