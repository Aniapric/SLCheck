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
  echo "Utilizare: $0 [--follow-symlinks] <director> "
  exit 1
fi

process_directory(){
  local current_dir="$1"
  if [ ! -r "$current_dir" ]; then
    echo "Avertisment: Eroare citire director $current_dir "
    return
  fi
  
  for file in "$current_dir"/*; do
    if [ ! -e "$file" ] && [ ! -L "$file" ]; then continue; fi

    if [  -L "$file" ]; then
       if [ ! -e "$file" ]; then
           echo "[BROKEN LINK] $file"
       elif [ -d "$file" ] && [ "$FOLLOW_SYMLINKS" = true ]; then
              process_directory "$file"
       fi

    elif [ -d "$file" ]; then
        process_directory "$file"
    fi

  done
}

echo "Analizez directorul: $TARGET_DIR"
process_directory "$TARGET_DIR"
