#!/bin/bash

backup_and_compress_tar() {
    local modpack_name=$1
    local backup_location="$minecraft_base/$modpack_name"

    # Start the log
    echo "[$(date)] Starting backup process for $modpack_name" > "$log_file"

    # Check if a folder called "backup" or "backups" exists in the destination
    if folder_exists "$backup_location/backup" || folder_exists "$backup_location/backups" || folder_exists "backup_location/simplebackups"; then
        echo "[$(date)] Backup or Backups folder already exists. Skipping backup process." >> "$log_file"
        return 0  # Skip the backup process
    fi

    local current_date=$(date +"%Y%m%d")
    # Define a unique backup filename using folder name and date
    backup_filename="backup_${modpack_name##*/}_$current_date.tar.gz"
    echo "[$(date)] Backup filename: $backup_filename" >> "$log_file"

    # Check if the backup file already exists, and create a unique filename if it does
    local count=1
    while [ -e "$backup_destination/$backup_filename" ]; do
        backup_filename="backup_${modpack_name##*/}_$current_date-$count.tar.gz"
        count=$((count + 1))
    done
    echo "[$(date)] Final backup filename after checking for duplicates: $backup_filename" >> "$log_file"

    # Check if pigz is available, otherwise use tar with default gzip
    if command -v pigz &> /dev/null; then
        echo "[$(date)] Using pigz for compression." >> "$log_file"
        tar -I pigz -cf "$backup_destination/$backup_filename" -C "$backup_location" . &>> "$log_file"
    else
        echo "[$(date)] pigz not found, using gzip with tar." >> "$log_file"
        tar -czf "$backup_destination/$backup_filename" -C "$backup_location" . &>> "$log_file"
    fi

    # Check if the tar command was successful
    if [ $? -eq 0 ]; then
        echo "[$(date)] Backup completed successfully. Backup file: $backup_destination/$backup_filename" >> "$log_file"
        return 0
    else
        echo "[$(date)] ERROR: Backup and compression failed. Check the tar output in $log_file." >> "$log_file"
        return 1
    fi
}
