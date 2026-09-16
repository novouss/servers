#!/bin/bash

DEBUG=false
BASE_DIR="."
TYPE="*.m4a"

while [[ $# -gt 0 ]]; do
    case "$1" in 
        --type=*)
	   TYPE="*.${1#*=}"
	   shift
	   ;; 
        -y|--yes)
	    DEBUG=true
	    shift
	    ;;
        e)
	    echo "Unknown option: $1"
	    ;;
    esac
done

# Function to process files
process_files() {
    find "$BASE_DIR" -type f -name $TYPE | while read -r file; do

        artist=$(echo "$file" | cut -d'/' -f2)
        album=$(echo "$file" | cut -d'/' -f3)
        filename=$(basename "$file")
        
        # Extract disc number and track number from filename (format: DD-TT Song Name.m4a)
        if [[ $filename =~ ^[0-9]+-[0-9]+[[:space:]]+(.*)\.${TYPE#*.}$ ]]; then
	    song_name="${BASH_REMATCH[1]}"
            
            # Construct new filename with Disc and Track prefixes
            new_filename="$artist - $song_name.${TYPE#*.}"
            new_file="$BASE_DIR/$artist/$album/$new_filename"
            old_file="$BASE_DIR/$artist/$album/$filename"
            
            if [ "$DEBUG" = true ]; then
                # Actually make the changes
                # Check if file already exists at destination
                if [ -f "$new_file" ]; then
                    echo "Warning: $new_file already exists! Skipping..."
                elif [ "$old_file" != "$new_file" ]; then
                    mv "$old_file" "$new_file"
                    echo "Renamed: $old_file -> $new_file"
                else
                    echo "Skipping: $old_file (already in correct format)"
                fi
            else
                # Preview mode
                if [ "$old_file" != "$new_file" ]; then
                    echo "Would rename:"
                    echo "  From: $old_file"
                    echo "  To:   $new_file"
                    echo ""
                else
                    echo "Already correct: $old_file"
                fi
            fi
        # else
            # echo "Warning: Skipping file with unexpected format: $file"
        fi
    done
}

# Check if songs directory exists
if [ ! -d "$BASE_DIR" ]; then
    echo "Error: $BASE_DIR directory not found!"
    exit 1
fi

# Display current mode
if [ "$DEBUG" = true ]; then
    echo "DEBUG mode: ON - Files will be RENAMED"
    echo "New format: Artist Name - Song Name.${TYPE#*.}"
else
    echo "DEBUG mode: OFF - Preview only (no changes will be made)"
    echo "Target format: Artist Name - Song Name.${TYPE#*.}"
fi
echo "----------------------------------------"

# Count files to be processed
file_count=$(find "$BASE_DIR" -type f -name $TYPE | wc -l)
echo "Found $file_count $TYPE files to process"
echo ""

# Ask for confirmation in DEBUG mode
if [ "$DEBUG" = true ]; then
    read -p "Are you sure you want to proceed with renaming files? (y/n): " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        echo "Operation cancelled."
        exit 0
    fi
fi

# Process the files
process_files

echo "Done!"
