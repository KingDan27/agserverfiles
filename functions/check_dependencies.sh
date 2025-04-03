#!/bin/bash

# Function to check if required dependencies are installed
check_dependencies() {
    for cmd in screen tar pigz; do
        if ! command -v $cmd &> /dev/null; then
            echo "$cmd is not installed. Please install it and try again."
            exit 1
        fi
    done
}
