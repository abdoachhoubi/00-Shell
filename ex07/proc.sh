#!/bin/bash

# Color codes for text formatting
RED_BOLD="\033[1;31m"
GREEN_BOLD="\033[1;32m"
YELLOW_BOLD="\033[1;33m"
BLUE_BOLD="\033[1;34m"
MAGENTA_BOLD="\033[1;35m"
CYAN_BOLD='\033[1;36m'
WHITE_BOLD='\033[1;37m'
RESET='\033[0m'

# Store the process list in an array
PROCESS=()

# Populate the array with process information (excluding header)
while read line; do
    PROCESS+=("$line")
done < <(ps aux | tail -n +2)

# Function to print the process list
function print_list() {
    PID_ARRAY=()
    echo -e $BLUE_BOLD"INDEX\tPID\tCMD"$RESET
    for i in "${PROCESS[@]}"; do
        PID_ARRAY+=("$i")
        echo -n -e $CYAN_BOLD"${#PID_ARRAY[@]}\t$RESET"
        echo -e $CYAN_BOLD"$i$RESET" | awk '{print $2, "\t", $11}'
    done
}

# Function to print the menu
function print_menu() {
    echo -e $GREEN_BOLD"1. List processes"$RESET
    echo -e $GREEN_BOLD"2. Kill process"$RESET
    echo -e $GREEN_BOLD"3. Exit"$RESET
}

# Function for the infinite loop to manage user choices
function infinite_loop() {
    while true; do
        print_menu
        echo -en $WHITE_BOLD"Enter your choice: "$RESET
        read CHOICE

        # Check for NULL input
        if [[ -z "$CHOICE" ]]; then
			echo
			exit 0
        fi

        # Validate input as a number
        if ! [[ "$CHOICE" =~ ^[0-9]+$ ]]; then
            echo -e $RED_BOLD"Invalid choice. Please enter a number"$RESET
            continue
        fi

        case $CHOICE in
            1) print_list ;;
            2)
                print_list
                echo -en $WHITE_BOLD"Enter the INDEX of the process to kill: "$RESET
                read INDEX

                # Check for empty or non-numeric input
                if [[ -z "$INDEX" || ! "$INDEX" =~ ^[0-9]+$ ]]; then
                    echo -e $RED_BOLD"Invalid index"$RESET
                    continue
                fi

                # Check if index is out of range
                if [[ "$INDEX" -le 0 || "$INDEX" -gt ${#PID_ARRAY[@]} ]]; then
                    echo -e $RED_BOLD"Invalid index"$RESET
                else
                    kill -9 $(echo ${PID_ARRAY[$INDEX - 1]} | awk '{print $2}')
                fi
                ;;
            3) exit 0 ;;
            *) echo -e $RED_BOLD"Invalid choice"$RESET ;;
        esac
    done
}

# Clear the screen and display header art
clear
echo -e $RED_BOLD"._____________________________________________."
echo -e $RED_BOLD"|  ┏━┳━┳━┳━┓                                  |"
echo -e $RED_BOLD"|  ┃╋┃╋┃┃┃┏┛ proc v1.1                        |"
echo -e $RED_BOLD"|  ┃┏┫┓┫┃┃┗┓ Process manager                  |"
echo -e $RED_BOLD"|  ┗┛┗┻┻━┻━┛ List and kill processes          |"
echo -e $RED_BOLD"|_____________________________________________|\n"$RESET

# Check if input is being piped
if [ -t 0 ]; then
    infinite_loop
else
    echo -e $RED_BOLD"Cannot run in a piped command"$RESET
	echo -e $WHITE_BOLD"Click enter to exit"$RESET
fi
