#!/bin/bash

# Function to run startup.sh in the modpack_name
run_startup_script() {
    modpack_name=$1
    prefixed_screen_session="MC$modpack_name"
    echo "Running startup.sh in screen session $prefixed_screen_session..."
    cd "$minecraft_base/$modpack_name" && sh "$minecraft_base/$modpack_name/startup.sh"
}
