# Function to create a unique log file based on the script or file that calls it
create_log_file() {
    local log_creator="$1"  # The identifier or script name passed to create the log file

    # Define log directory and ensure it exists
    local log_dir="/home/dan/minecraft/scripts/logs/${log_creator}"
    mkdir -p "$log_dir"

    # Create a unique log file with the script name and timestamp
    log_file="$log_dir/${log_creator}_$(date +"%Y%m%d_%H%M%S").log"

    # Redirect stdout and stderr to the log file
    exec > >(tee -a "$log_file") 2>&1

    echo "Log file created for $log_creator at $log_file"
    # Call manage_logs to clean up old logs
    manage_logs "$log_dir"
}

# Function to manage logs
manage_logs() {
    local log_dir="$1"  # Accept log directory as an argument

    # Remove logs older than 3 days
    find "$log_dir" -type f -name "*.log" -mtime +3 -exec rm -f {} \;

    # Keep only the last 7 log files
    ls -tp "$log_dir"/*.log | tail -n +8 | xargs -I {} rm -- {}
}
