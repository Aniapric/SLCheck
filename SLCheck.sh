#!/bin/bash

FOLLOW_SYMLINKS=false
TARGET_DIR=""

for arg in "$@"; do
    if [ "$arg" = "--follow-symlinks" ]; then
        FOLLOW_SYMLINKS=true
    elif [ -z "$TARGET_DIR" ]; then
        TARGET_DIR="$arg"
    fi
done

if [ -z "$TARGET_DIR" ]; then
    echo "Utilizare: $0 [--follow-symlinks] <director>"
    exit 1
fi

if [ ! -d "$TARGET_DIR" ]; then
    echo "Eroare: $TARGET_DIR nu este un director valid"
    exit 1
fi

declare -A VISITED_INODES

process_directory() {
     local current_dir="$1"
    
     if [ ! -r "$current_dir" ] || [ ! -x "$current_dir" ]; then
        echo "Avertisment: Nu pot accesa directorul $current_dir"
        return
     fi
     
     local dir_id=$(stat -c "%d:%i" "$current_dir")
     
     if [ -n "${VISITED_INODES[$dir_id]}" ]; 
       then echo "[INFO] Ciclu detectat sau director deja vizitat: $current_dir (Sarit)"
       return
     fi
     VISITED_INODES[$dir_id]=1

     for entry in "$current_dir"/*; do

        if [ -L "$entry" ]; then

            if [ ! -e "$entry" ]; then
                echo "[BROKEN LINK] $entry"
                continue
            fi

            if [ -d "$entry" ] && [ "$FOLLOW_SYMLINKS" = true ]; then
                process_directory "$entry"
            fi

        elif [ -d "$entry" ]; then
            process_directory "$entry"
        fi

     done
}

echo "Analizez directorul: $TARGET_DIR"
process_directory "$TARGET_DIR"
