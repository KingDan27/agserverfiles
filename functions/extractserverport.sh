# Function to extract the server port from server.properties
extract_server_port() {
    local modpack_name=$1
    local minecraft_base="/home/dan/minecraft"
    local properties_file="$minecraft_base/$modpack_name/server.properties"

    # Check if the server.properties file exists
    if [ -f "$properties_file" ]; then
        # Extract the line that starts with 'server-port=' and store the value after '='
        server_port=$(grep "^server-port=" "$properties_file" | cut -d'=' -f2 | xargs)

        # Check if the server port was found
        if [ -n "$server_port" ]; then
            echo "$server_port"  # Only return the port number
        else
            echo "No server-port found in $properties_file." >&2
            return 1
        fi
    else
        echo "$properties_file does not exist." >&2
        return 1
    fi
}
