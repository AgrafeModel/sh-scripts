#!/bin/bash

# This script is used to watch a folder and execute a command when a file is created, modified or deleted
# It uses fswatch or inotifywait depending on the OS
# Usage: ./watcher.sh [folder_to_watch]
# Default folder_to_watch is .


# Dossier à surveiller
FOLDER_TO_WATCH="."

if [ $# -eq 1 ]; then
    FOLDER_TO_WATCH="$1"
fi


function action() {

    echo "Change detected in $FOLDER_TO_WATCH"
    ## ---- Do your stuff here ---- ##
    echo "Doing something..."
    ## ---- Do your stuff here ---- ##
}

action

# check if macos
if [[ "$OSTYPE" == "darwin"* ]]; then
    # check if fswatch is installed
    if ! command -v fswatch &> /dev/null
    then
        echo "fswatch is not installed. Please install it using 'brew install fswatch'"
        exit 1
    fi


    fswatch -o "$FOLDER_TO_WATCH" | while read change
    do
        action
    done
fi

# check if linux
if [[ "$OSTYPE" == "linux-gnu" ]]; then
     # check if inotifywait is installed
    if ! command -v inotifywait &> /dev/null
    then
        echo "inotifywait is not installed. Please install it using 'sudo apt install inotify-tools'"
        exit 1
    fi

    inotifywait -e modify -e create -e delete -e move -r "$FOLDER_TO_WATCH" | while read change
    do
        action
    done
fi
