#!/bin/bash

# Help Message
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PINK='\033[0;35m'
CYAN='\033[0;36m'
ORANGE='\033[0;91m'
VIOLET='\033[0;92m'
RESET='\033[0m'

# Quits when user types q/Q
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
    echo -e "\nname\t\t${GREEN}backup${RESET}"
    echo -e "utility\t\t${YELLOW}performs regular backups of a specified directory${RESET}\n"
    echo "usage:"
    echo -e "\t\tDisplay help:\t${GREEN}./backup -h${RESET}"
    echo -e "\t\tPerform backup:\t${GREEN}./backup [options] [dir]${RESET}\n"
    echo "params:"
    echo -e "\t\t- ${YELLOW}options${RESET}:\n\t\t\t[-c]\tCompress directory\n\t\t\t[-t]\tAdd timestamps\n\t\t\t[-ct]\tDo both\n"
    echo -e "\t\t- ${YELLOW}dir${RESET}:\tpath to the directory"
    echo -n ":"
    quit
}

# Handling args
ARG_LEN=${#@}

# Handles number of args
if [ $ARG_LEN == 0 ] || { [ $ARG_LEN == 1 ] && [ $1 == "-h" ]; }; then
    display_help
    if [ $ARG_LEN == 0 ]; then
        exit 1
    fi
    exit 0
fi

# Parsing
DIR="[default]"
OPTIONS="[default]"

if [ $ARG_LEN == 1 ]; then
    if [ -d $1 ]; then
        DIR=$1
    fi
    
    elif [ $ARG_LEN = 2 ]; then
    if [ -d $1 ] && { [ $2 == "-r" ] || [ $2 == "-c" ] || [ $2 == "-t" ] || [ $2 == "-ct" ] || [ $2 == "-tc" ]; }; then
        DIR=$1
        OPTIONS=$2
        elif [ -d $2 ] && { [ $1 == "-r" ] || [ $1 == "-c" ] || [ $1 == "-t" ] || [ $1 == "-ct" ] || [ $1 == "-tc" ]; }; then
        DIR=$2
        OPTIONS=$1
    else
        echo -e "${RED}Error:\n\tInvalid arguments\n${RESET}"
        display_help
    fi
else
    echo -e "${RED}Error:\n\tInvalid number of arguments\n${RESET}"
    display_help
fi

# Check if $dir is a directory
if [ ! -d $dir ]; then
    echo -e "${RED}Error:\n\t$dir is not a directory!"
    exit 1
fi

BACKUP_DIR="$HOME/.backup_dir"

mkdir -p $BACKUP_DIR

function display_success()
{
    echo -e "${GREEN}Done!\nBackUp will be saved in: ${RESET}${1}"
}

IFS="/"
DIR_SPLIT=($DIR)
LAST_INDEX=$((${#DIR_SPLIT[@]} - 1))
ARCHIVE_DIR="${BACKUP_DIR}/${DIR_SPLIT[$LAST_INDEX]}"
ARCHIVE="${ARCHIVE_DIR}/${DIR_SPLIT[$LAST_INDEX]}.tar"

mkdir -p "$ARCHIVE_DIR"

function backup()
{
    DATE=$(date +"%Y%m%d_%H%M%S")
    if [ $OPTIONS == "-c" ]; then
        tar "$1" "$ARCHIVE" "$DIR"
        elif [ $OPTIONS == "-t" ]; then
        cp -r "$DIR" "$ARCHIVE_DIR/${DIR_SPLIT[$LAST_INDEX]}_${DATE}"
        elif [ $OPTIONS == "-ct" ] || [ $OPTIONS == "-tc" ]; then
        tar "$1" "$ARCHIVE_DIR/${DIR_SPLIT[$LAST_INDEX]}_${DATE}.tar" "$DIR"
    else
        rm -rf "$ARCHIVE_DIR/${DIR_SPLIT[$LAST_INDEX]}"
        cp -r "$DIR" "$ARCHIVE_DIR/${DIR_SPLIT[$LAST_INDEX]}"
    fi
}

display_success "$ARCHIVE_DIR"

echo $$ > "${ARCHIVE_DIR}/.pid"
cp "backup_utils.sh" "${ARCHIVE_DIR}/backup_utils.sh"

while true; do
    backup "-czf"
    sleep 30
done &