# Function to send a formatted notification to Discord using embeds
send_discord_notification() {
    local modpack_name=$1
    local status=$2  # status could be "success" or "failure"
    # Color depending on status: Green (3066993) for success, Red (15158332) for failure
    local color=$([ "$status" == "success" ] && echo "3066993" || echo "15158332")
    local message_title=$3
    local message_description=$4
    local serverip=$5
    . $settings_cfg
    # Construct the JSON payload with an embed
    payload=$(cat <<EOF
{
    "embeds": [{
        "title": "$message_title",
        "description": "$message_description",
        "color": $color,
        "thumbnail": {
                "url": "https://github.com/KingDan27/agserverfiles/blob/main/minecraftcontentlogo.png?raw=true"
              },
        "fields": [
            {
                "name": "Modpack",
                "value": "$modpack_name",
                "inline": true
            },
            {
              "name": "Server IP",
              "value": "$serverip",
              "inline": true

            },
            {
                "name": "Status",
                "value": "$status",
                "inline": true
            }
        ],
        "footer": {
            "text": "Sent by Ardent Gaming"
        },
        "timestamp": "$(date -Iseconds)"
    }]
}
EOF
)

    # Send the payload to the Discord webhook using curl
    curl -H "Content-Type: application/json" -X POST -d "$payload" "$discord_webhook_url_general" &>/dev/null

    # Log the notification
    echo "[$(date)] Sent Discord notification: $message_description" #>> "$minecraft_base/logs/discord_notification.log"
}

send_update_discord_notification() {
    local modpack_name=$1
    local status=$2  # status could be "success" or "failure"
    # Color depending on status: Green (3066993) for success, Red (15158332) for failure
    local color=$([ "$status" == "success" ] && echo "3066993" || echo "15158332")
    local message_title=$3
    local message_description=$4
    local serverip=$5
    local version=$6
    . $settings_cfg

    # Construct the JSON payload with an embed
    payload=$(cat <<EOF
{
    "embeds": [{
        "title": "$message_title",
        "description": "$message_description",
        "color": $color,
        "thumbnail": {
                "url": "https://github.com/KingDan27/agserverfiles/blob/main/minecraftcontentlogo.png?raw=true"
              },
        "fields": [
            {
                "name": "Modpack",
                "value": "$modpack_name",
                "inline": true
            },
            {
                "name": "Version",
                "value": "$version",
                "inline": true
            },
            {
              "name": "Server IP",
              "value": "$serverip",
              "inline": true

            },
            {
                "name": "Status",
                "value": "$status",
                "inline": true
            }
        ],
        "footer": {
            "text": "Sent by Ardent Gaming"
        },
        "timestamp": "$(date -Iseconds)"
    }]
}
EOF
)

    # Send the payload to the Discord webhook using curl
    curl -H "Content-Type: application/json" -X POST -d "$payload" "$discord_webhook_url_update" &>/dev/null

    # Log the notification
    echo "[$(date)] Sent Discord notification: $message_description" #>> "$minecraft_base/logs/discord_notification.log"
}
