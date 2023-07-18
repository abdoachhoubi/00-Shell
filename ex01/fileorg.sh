#!/bin/bash

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PINK='\033[0;35m'
CYAN='\033[0;36m'
ORANGE='\033[0;91m'
VIOLET='\033[0;92m'
RESET='\033[0m'

function quit() {
    # Disable character echoing and buffering
    stty -echo
    stty -icanon
    
    # Loop to read and handle each character of input
    while IFS= read -r -n 1 char; do
        # Break the loop if the user presses Enter
        if [[ $char == $'q' ]]; then
            clear
            break
        fi
    done
    
    # Enable character echoing and reset terminal settings
    stty echo
    stty icanon
    
    echo
}

# help function
function display_help() {
    echo
    echo -e "name\t\t${GREEN}fileorg${RESET}"
    echo -e "utility\t\t${YELLOW}organizes files${RESET}"
    echo
    echo "usage:"
    echo -e "\t\tDisplay help:\t${GREEN}./fileorg -h${RESET}"
    echo -e "\t\tOrganize files:\t${GREEN}./fileorg [dir] [new_dir] [ext]${RESET}"
    echo
    echo "params:"
    echo -e "\t\t- ${YELLOW}dir${RESET}: path to the directory in which files to organize"
    echo -e "\t\t- ${YELLOW}new_dir${RESET}: name of the new directory in which everything will be organized. If the directory already exists, it will be used without affecting its content."
    echo -e "\t\t- ${YELLOW}ext (optional)${RESET}: when specified, only files that have the specified extension will be organized"
    echo -n ":"
    quit
}

# Arg error
if [ $# -eq 0 ] || [ -z "$1" ] || [ -z "$2" ]; then
    echo "Error: Invalid arguments"
    display_help
    exit 1
fi

# Display help
if [ "$1" == "-h" ]; then
    display_help
    exit 0
fi

# Getting all params
dir="$1"
new_dir="$2"
ext="$3"
default_ifs=$IFS

# Check if dir exists
if [ ! -d "$dir" ]; then
    echo "Error: Directory doesn't exist!"
    exit 1
fi

# Check if new_dir exists
if [ -d "$new_dir" ]; then
    echo "Directory $new_dir already exists!"
    echo -n "Would you like to use it? [Y/N] (default: Y): "
    read -r res
    if [[ "$res" == "N" ]]; then
        exit 0
    fi
fi

# making the new dir in case it doesn't exist
mkdir -p "$new_dir"

# copies files with a specific ext to their dir
function single_ext() {
    local file=$1
    local new_dir=$2
    IFS='.'
    local file_split=($file)
    local last_index=$((${#file_split[@]} - 1))
    local file_ext=${file_split[$last_index]}
    if [ $ext == $file_ext ]; then
        cp "$file" "$new_dir"
    fi
}

# handle single command case
if [ $# -eq 3 ]; then
    ext_dir="$new_dir/$ext"
    mkdir -p $ext_dir
    IFS=$default_ifs
    for file in "$dir"/*; do
        if [ ! -d "$file" ]; then
            single_ext "$file" "$ext_dir"
        fi
    done
    echo "Done"
    exit 0
fi

# copies files to their corresponding directory
function copy_files() {
    local file=$1
    IFS='.'
    local file_split=($file)
    local last_index=$((${#file_split[@]} - 1))
    local file_ext=${file_split[$last_index]}
    if [ ! -d "$new_dir/$file_ext" ]; then
        mkdir -p "$new_dir/$file_ext"
    fi
    cp "$file" "$new_dir/$file_ext"
}

# looping over files and calling copy_files for each file
IFS=$default_ifs
for file in "$dir"/*; do
    if [ ! -d "$file" ]; then
        copy_files "$file"
    fi
done

echo "Done"

