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
    echo -e "\nname\t\t${GREEN}backup_utils${RESET}"
    echo -e "utility\t\t${YELLOW}a util that can help you manage your backup${RESET}\n"
    echo "usage:"
    echo -e "\t\tDisplay help:\t${GREEN}./backup_utils -h${RESET}"
    echo -e "\t\tUse utils:\t${GREEN}./backup_utils [option]${RESET}\n"
    echo "params:"
    echo -e "\t\t- ${YELLOW}options${RESET}:\n\t\t\t[-h]\tDisplay help\n\t\t\t[-x]\tExtract backup\n\t\t\t[-s]\tStop backup\n"
    echo -n ":"
    quit
}

function kill_proc()
{
    # List of all backup.sh processes
    LIST_PROC=`pgrep -f backup.sh`
    
    if [ ${#LIST_PROC[0]} == 0 ]; then
        echo "No backup process running"
        exit 0
    fi
    
    function kill_backup()
    {
        local PROCESS=$1
        # Initialize variables to store the nearest number and the minimum difference
        local PROC=${LIST_PROC[0]}
        local min_diff=$(( ${PROCESS} - ${LIST_PROC[0]} ))
        if (( min_diff < 0 )); then
            min_diff=$(( -min_diff ))
        fi
        
        # Loop through the list of numbers to find the nearest one
        for pid in "${LIST_PROC[@]}"; do
            diff=$(( ${PROCESS} - ${pid} ))
            if (( diff < 0 )); then
                diff=$(( -diff ))
            fi
            if (( diff < min_diff )); then
                min_diff=${diff}
                PROC=${pid}
            fi
        done
        kill $PROC
        echo -e "${GREEN}Process ${YELLOW}$PROC${RESET} ${GREEN}has been terminated successfully!${RESET}"
    }
    
    if [ -e "./.pid" ]; then
        PID=`cat ./.pid`
        kill_backup $PID
    else
        for pid in $LIST_PROC; do
            echo -e "${GREEN}Process ${YELLOW}$pid${RESET} killed successfully${RESET}"
            kill $pid
        done
    fi
}

if [ ${#} != 1 ] || { [ ${#} == 1 ] && [ $1 == "-h" ]; }; then
    display_help
    exit 0
else
    if [ $1 == "-x" ] && [ -e ./*.tar ]; then
        tar -xvf ./*.tar
        elif [ $1 == "-x" ] && [ ! -e ./*.tar ]; then
        echo -e "${RED}Error:\n\tCouldn't find any tar file to extract!${RESET}"
        elif [ $1 == "-s" ]; then
        kill_proc
    else
        echo -e "${RED}Error:\n\tInvalid arguments\n"
        display_help
        exit 1
    fi
fi