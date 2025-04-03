#!/bin/bash
config_dir="/home/dan/minecraft/scripts/config/"
settings_cfg="$config_dir/settings.cfg"

. "$settings_cfg"
modpack_name=$1  # Use the first argument as the modpack name
version=$2  # Use the second argument as the update version number

# If modpack name or version number is not provided as an argument, prompt the user
if [ -z "$1" ] || [ -z "$2" ]; then
    echo "Usage: $0 <modpack_name> <version_number>"
    exit 1
fi

# Function to check if all necessary function files exist
check_and_source_function_files() {
    # List of required function files
    local required_files=(
        "check_dependencies.sh"
        "send_command_and_close_screen.sh"
        "folder_exists.sh"
        "backup_and_compress_tar.sh"
        "delete_subfolders.sh"
        "copy_subfolders.sh"
        "run_startup_script.sh"
        "discordnotification.sh"
        "extractserverport.sh"
        "create_log_function.sh"
    )

    # Check for each required file and source it
    for file in "${required_files[@]}"; do
        if [[ ! -f "$pathtofunctions/$file" ]]; then
            echo "Error: Required function file '$file' is missing in '$pathtofunctions'."
            exit 1
        else
            # Source the function file
            . "$pathtofunctions/$file"
            echo "Sourced $file successfully."
        fi
    done
}

# Call the function to check and source all needed functions
check_and_source_function_files

create_log_file update_logs

# Main script
check_dependencies  # Ensure dependencies are installed
extract_server_port $modpack_name
send_update_discord_notification "$modpack_name" "success" "Update Notification" "${modpack_name}'s update has started" "games.ardentgaming.ca:$server_port" "$version"

send_command_and_close_screen "$modpack_name"

# Perform the backup and compression
backup_and_compress_tar "$modpack_name"

# Proceed if the backup was successful
if [ $? -eq 0 ]; then
    delete_subfolders "$modpack_name"
    copy_subfolders
    run_startup_script "$modpack_name"
    echo "Backup, compression, and subfolder operations completed."
    send_update_discord_notification "$modpack_name" "success" "Update Notification" "$modpack_name was updated successfully" "games.ardentgaming.ca:$server_port" "$version"
else
    echo "Backup and compression failed. Skipping subfolder operations."
    send_update_discord_notification "$modpack_name" "failure" "Update Notification" "$modpack_name update failed" "games.ardentgaming.ca:$server_port" "$version"
fi

echo "Script completed at $(date)."
