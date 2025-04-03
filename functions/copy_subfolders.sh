#!/bin/bash

# Function to copy subfolders from updateprep to modpack_name
copy_subfolders() {
    echo "removing old libraries folder"
    rm -rv "$minecraft_base/$modpack_name/libraries"

    echo "Copying subfolders from $updateprep_folder to $minecraft_base/$modpack_name..."
    cp -r "$updateprep_folder"/* "$minecraft_base/$modpack_name"

    # Check if the copy was successful
    if [ $? -eq 0 ]; then
        echo "Subfolders copied successfully. Removing files from updateprep..."
        rm -r "$updateprep_folder"/*

        # Verify that updateprep is empty
        if [ -z "$(ls -A "$updateprep_folder")" ]; then
            echo "Files and folders in updateprep have been removed successfully."
        else
            echo "Failed to remove files and folders from updateprep."
        fi
    else
        echo "Failed to copy subfolders. No changes made to updateprep."
    fi
}
