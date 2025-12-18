# SLCheck

SLCheck is a Linux shell script that detects broken symbolic links by recursively
traversing directories, without relying on external tools such as `find` or
`readlink`.

The script scans a target directory and reports symbolic links that point to
non-existent files or directories. An optional flag allows following directory
symlinks during traversal.

Features:
- Recursive directory traversal
- Detection of broken symbolic links
- Optional following of directory symlinks using `--follow-symlinks`
- Implemented in pure Bash

Usage:
Make the script executable if necessary:
chmod +x SLCheck.sh

Run the script on a directory:
./SLCheck.sh <directory>

Run the script while following directory symlinks:
./SLCheck.sh --follow-symlinks <directory>

Requirements:
- Linux operating system
- Bash shell

This project was developed as an academic exercise to practice Linux filesystem
navigation, shell scripting, recursion, and command-line tool design.

#### **Created by Ania Pricop.**
