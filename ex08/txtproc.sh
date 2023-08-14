#!/bin/bash

# Colors for formatting
RED_BOLD="\033[1;31m"
GREEN_BOLD="\033[1;32m"
YELLOW_BOLD="\033[1;33m"
BLUE_BOLD="\033[1;34m"
MAGENTA_BOLD="\033[1;35m"
CYAN_BOLD='\033[1;36m'
WHITE_BOLD='\033[1;37m'
RESET='\033[0m'

# Function to display the manual
function manual() {
    echo -e "$GREEN_BOLD""NAME""$RESET"
    echo -e "\t$0 - Count the number of occurrences of each word in a text file"
    echo
    echo -e "$GREEN_BOLD""SYNOPSIS""$RESET"
    echo -e "\t$0 [OPTION]... [FILE]..."
    echo
    echo -e "$GREEN_BOLD""DESCRIPTION""$RESET"
    echo -e "\tReads the given FILE and counts the number of occurrences of each word in it."
    echo
    echo -e "$GREEN_BOLD""OPTIONS""$RESET"
    echo -e "\t-h, --help"
    echo -e "\t\tPrints this manual and exits"
    echo
    echo -e "\t-v, --version"
    echo -e "\t\tPrints version information and exits"
    echo
    echo -e "$GREEN_BOLD""AUTHOR""$RESET"
    echo -e "\tWritten by $GREEN_BOLD""Astro""$RESET"
}

# Display version information
if [[ "$1" == "-v" || "$1" == "--version" ]]; then
    echo -e "$GREEN_BOLD""txtproc (ASTRO coreutil) 1.0""$RESET"
    echo -e "License MIT: <https://opensource.org/licenses/MIT>"
    echo -e "This is a free script; you are free to change and redistribute it."
    echo -e "There is NO WARRANTY, to the extent permitted by law."
    exit 0
fi

# Display help information
if [[ "$1" == "-h" || "$1" == "--help" ]]; then
    manual
    exit 0
fi

# Check for valid number of arguments
if [[ $# -lt 1 || $# -gt 2 ]]; then
    echo -e "$RED_BOLD""Error: Invalid number of arguments""$RESET"
    echo -e "Try '$0 --help' for more information."
    exit 1
fi

# Check for valid file
if [[ ! -f "$1" ]]; then
    echo -e "$RED_BOLD""Error: $1 is not a file""$RESET"
    exit 1
fi

# Handle the case where no output file is provided
if [[ $# -eq 1 ]]; then
    cat "$1" | tr -s '[:space:]' '\n' | sort | uniq -c | sort -nr
    exit 0
fi

# Check if output file is the same as the input file
if [[ "$1" == "$2" ]]; then
    echo -e "$RED_BOLD""Error: $1 and $2 are the same file""$RESET"
    exit 1
fi

# Check if output file is a directory
if [[ -d "$2" ]]; then
    echo -e "$RED_BOLD""Error: $2 is a directory""$RESET"
    exit 1
fi

# Check for a valid output file
if [[ $# -eq 2 && -f "$2" ]]; then
    echo -e "$RED_BOLD""Error: $2 already exists""$RESET"
    echo -n -e "$WHITE_BOLD""Do you want to overwrite it? (y/n): ""$RESET"
    read CHOICE
    if [[ "$CHOICE" == "y" || "$CHOICE" == "Y" ]]; then
        echo -e "$YELLOW_BOLD""Overwriting file $2...""$RESET"
        cat "$1" | tr -s '[:space:]' '\n' | sort | uniq -c | sort -nr > "$2"
        echo -e "$GREEN_BOLD""File $2 overwritten successfully""$RESET"
        exit 0
    elif [[ "$CHOICE" == "n" || "$CHOICE" == "N" ]]; then
        echo -e "$YELLOW_BOLD""Exiting...""$RESET"
        exit 0
    else
        echo -e "$RED_BOLD""Error: Invalid choice""$RESET"
        exit 1
    fi
    exit 1
fi

# Main logic
echo -e "$YELLOW_BOLD""Creating file $2...""$RESET"
cat "$1" | tr -s '[:space:]' '\n' | sort | uniq -c | sort -nr > "$2"
echo -e "$GREEN_BOLD""File $2 created successfully""$RESET"
exit 0
