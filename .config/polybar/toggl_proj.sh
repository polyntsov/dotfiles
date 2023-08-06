#!/bin/zsh

function current_task () {
    task=$(toggl ls --today -f 'project, description, stop' | \
        grep running | \
        awk -F' \\(#|\\)  |  ' '{project=$1; $1=""; $2=""; sub(/^[ \t]+/, "", $0); print project ": " substr($0, 0, length($0)-length($NF)-1)}' | \
        sed 's/^[[:space:]]*//;s/[[:space:]]*$//')
    echo "$task"
}

current_task
