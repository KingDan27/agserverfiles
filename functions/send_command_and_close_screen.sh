#!/bin/bash

# Function to close a screen session with a static prefix
send_command_and_close_screen() {
    modpack_name=$1
    prefixed_screen_session="MC$modpack_name"

    # Check if the specified screen session exists
    if ! screen -list | grep -q "$prefixed_screen_session"; then
        echo "Screen session '$prefixed_screen_session' does not exist. Current screen sessions:"
        screen -ls
        echo "Enter a valid modpack name: "
        read modpack_name
        prefixed_screen_session="MC$modpack_name"
    fi

    echo "Closing screen session $prefixed_screen_session"
    screen -S "$prefixed_screen_session" -X quit
    sleep 1s
    # Check if the session actually closed
    if screen -list | grep -q "$prefixed_screen_session"; then
        echo "Failed to close screen session $prefixed_screen_session."
        return 1
    fi

    echo "Screen session $prefixed_screen_session has closed."
}
