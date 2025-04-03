#!/bin/bash

# Function to restart the server
restart_server() {
    local modpack_name=$1
    local screen_name="MC$modpack_name"
    local startup_script="/home/dan/minecraft/$modpack_name/startup.sh"
    local startup_dir="/home/dan/minecraft/$modpack_name"

    echo "Restarting server for modpack: $modpack_name"

    # Send Ctrl+C to the running server process
    if screen -list | grep -q "$screen_name"; then
        echo "Stopping the server..."
        screen -S "$screen_name" -p 0 -X stuff "^C"
        sleep 5  # Wait for a moment to allow graceful shutdown
    fi

    # Kill any remaining server processes
    if screen -list | grep -q "\.$screen_name"; then
        echo "Server still running, attempting to kill the process."
        screen -S "$screen_name" -X quit
        sleep 3
    fi

    # Check if the server process still exists and kill it if needed
    if pgrep -f "$modpack_name"; then
        echo "Forcing server shutdown..."
        pkill -f "$modpack_name"
        sleep 2
    fi
	screen -wipe

    # Start the server again if no session is found
    if ! screen -list | grep -q "$screen_name"; then
        if [ -f "$startup_script" ]; then
            echo "Starting the server using $startup_script in directory $startup_dir..."
            (cd "$startup_dir" && screen -dmS "$screen_name" bash "$startup_script")  # Change to the directory and run in detached screen
            send_discord_notification "$modpack_name" "success" "Restart Notification" "$modpack_name has been restarted" "games.ardentgaming.ca:$server_port"

        else
            echo "Startup script $startup_script not found. Cannot start the server."
        fi
    else
        echo "A screen session for $screen_name already exists. Not starting a new session."
    fi
}
