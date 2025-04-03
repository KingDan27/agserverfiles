#!/bin/bash

# Function to delete subfolders based on folders in updateprep
delete_subfolders() {
    modpack_name=$1

    # Check if updateprep folder is empty
    if [ -z "$(ls -A "$updateprep_folder")" ]; then
        echo "updateprep is empty. Not deleting anything."
        return
    fi

    # Iterate over subfolders in updateprep and delete corresponding folders in modpack_name
    for subfolder in "$updateprep_folder"/*; do
        subfolder_name=$(basename "$subfolder")
        subfolder_path="$minecraft_base/$modpack_name/$subfolder_name"

        # Check if the subfolder exists in modpack_name before deleting
        if [ -d "$subfolder_path" ]; then
            echo "Deleting subfolder: $subfolder_path"
            rm -r "$subfolder_path"
        else
            echo "Subfolder '$subfolder_name' does not exist in $modpack_name."
        fi
    done
}
