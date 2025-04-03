#!/bin/bash

folder_exists() {
    folder=$1
    if [ -d "$folder" ]; then
        echo "Folder $folder already exists."
        return 0
    else
        return 1
    fi
}
