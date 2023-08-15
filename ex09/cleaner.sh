#!/bin/bash

# A script that can be used to show storage info (total, used, available, large files) and to clean the storage and suggests deleting useless files

# Colors
BOLD_RED="\033[1;31m"
BOLD_CYAN="\033[1;36m"
BOLD_GREEN="\033[1;32m"
BOLD_WHITE="\033[1;37m"
BOLD_YELLOW="\033[1;33m"
BOLD_BLUE="\033[1;34m"
BOLD_MAGENTA="\033[1;35m"
BOLD_BLACK="\033[1;30m"
RESET="\033[0m"

# A man-like function
function man(){
	echo -e "${BOLD_RED}NAME${RESET}"
	echo -e "\t${BOLD_WHITE}cleaner${RESET} - A script that can be used to show storage info (total, used, available, large files) and to clean the storage and suggests deleting useless files"
	echo -e "${BOLD_RED}SYNOPSIS${RESET}"
	echo -e "\t${BOLD_WHITE}cleaner${RESET} [${BOLD_GREEN}OPTION${RESET}]"
	echo -e "${BOLD_RED}DESCRIPTION${RESET}"
	echo -e "\t${BOLD_WHITE}cleaner${RESET} is a script that can be used to show storage info (total, used, available, large files) and to clean the storage and suggests deleting useless files"
	echo -e "${BOLD_RED}OPTIONS${RESET}"
	echo -e "\t${BOLD_GREEN}-h, --help${RESET}"
	echo -e "\t\tDisplay this help and exit"
	echo -e "\t${BOLD_GREEN}-t, --total${RESET}"
	echo -e "\t\tDisplay the total storage"
	echo -e "\t${BOLD_GREEN}-u, --used${RESET}"
	echo -e "\t\tDisplay the used storage"
	echo -e "\t${BOLD_GREEN}-a, --available${RESET}"
	echo -e "\t\tDisplay the available storage"
	echo -e "\t${BOLD_GREEN}-l, --large${RESET}"
	echo -e "\t\tDisplay the large files"
	echo -e "\t${BOLD_GREEN}-c, --clean${RESET}"
	echo -e "\t\tClean the storage and suggests deleting useless files"
	echo -e "${BOLD_RED}AUTHOR${RESET}"
	echo -e "\tWritten by ${BOLD_WHITE}Astro${RESET}"
}


function c_display()
{
	values=$1
	titles=$2
	LONGEST=$(cat titles | awk '{ print length }' | sort -nr | head -n 1)
	for i in $(cat titles); do

		echo -ne "${BOLD_WHITE}$i:  ${RESET}"
		for (( j=0; j<=$(( $LONGEST - ${#i} )); j++ )); do
			echo -ne " "
		done
		VAL=$(cat values | head -n 1)
		sed -i '1d' values
		echo -e "${BOLD_GREEN}$VAL${RESET}"
	done
}

# Display functions
function display_total(){
    echo -e "${BOLD_MAGENTA}Total storage:${RESET}"
    df -h --total | grep -vE "tmpfs|udev|loop|Filesystem|none" | awk '{ print $1 }' > ./titles
    df -h --total | grep -vE "tmpfs|udev|loop|Filesystem|none" | awk '{ print $2 }' > ./values
	c_display values titles
}

function display_used(){
    echo -e "${BOLD_MAGENTA}Used storage:${RESET}"
    df -h --total | grep -vE "tmpfs|udev|loop|Filesystem|none|total" | awk '{ print $1 }' > ./titles
    df -h --total | grep -vE "tmpfs|udev|loop|Filesystem|none|total" | awk '{ print $3 }' > ./values
	c_display values titles
}

function display_available(){
    echo -e "${BOLD_MAGENTA}Available storage:${RESET}"
    df -h --total | grep -vE "tmpfs|udev|loop|Filesystem|none|Used|total" | awk '{ print $1 }' > ./titles
    df -h --total | grep -vE "tmpfs|udev|loop|Filesystem|none|Used|total" | awk '{ print $4 }' > ./values
	c_display values titles
}

function display_large(){
    echo -e "${BOLD_MAGENTA}Large files:${RESET}"
    find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | awk '{ print $9 }' > ./titles
    find / -type f -size +100M -exec ls -lh {} \; 2>/dev/null | awk '{ print $5 }' > ./values
	c_display values titles
}


function clean(){
	echo -e "${BOLD_WHITE}Cleaning...${RESET}"

	# Cache
	if [ -d ~/.cache ]; then
		echo -e "${BOLD_WHITE}Checking for cache...${RESET}"
		echo -e "${BOLD_CYAN}Cache found.${RESET}"
		echo -ne "${BOLD_WHITE}Do you want to delete it? [y/n]: ${RESET}"
		read ans
		if [ "$ans" == "y" ]; then
			echo -e "${BOLD_CYAN}Deleting cache...${RESET}"
			rm -rf ~/.cache 2>/dev/null
			echo -e "${BOLD_GREEN}Cache deleted.${RESET}"
		else
			echo -e "${BOLD_YELLOW}Cache not deleted.${RESET}"
		fi
	else
		echo -e "${BOLD_CYAN}No cache found.${RESET}"
	fi

	# Trash
	if [ -d ~/.local/share/Trash ]; then
		echo -e "${BOLD_WHITE}Checking for trash...${RESET}"
		echo -e "${BOLD_CYAN}Trash found.${RESET}"
		echo -ne "${BOLD_WHITE}Do you want to delete it? [y/n]: ${RESET}"
		read ans
		if [ "$ans" == "y" ]; then
			echo -e "${BOLD_CYAN}Deleting trash...${RESET}"
			rm -rf ~/.local/share/Trash 2>/dev/null
			echo -e "${BOLD_GREEN}Trash deleted.${RESET}"
		else
			echo -e "${BOLD_YELLOW}Trash not deleted.${RESET}"
		fi
	else
		echo -e "${BOLD_CYAN}No trash found.${RESET}"
	fi

	# Old files
	if [ -d ~/old_files ]; then
		echo -e "${BOLD_WHITE}Checking for old files...${RESET}"
		echo -e "${BOLD_CYAN}Old files found.${RESET}"
		echo -ne "${BOLD_WHITE}Do you want to delete them? [y/n]: ${RESET}"
		read ans
		if [ "$ans" == "y" ]; then
			echo -e "${BOLD_CYAN}Deleting old files...${RESET}"
			rm -rf ~/old_files 2>/dev/null
			echo -e "${BOLD_GREEN}Old files deleted.${RESET}"
		else
			echo -e "${BOLD_YELLOW}Old files not deleted.${RESET}"
		fi
	else
		echo -e "${BOLD_CYAN}No old files found.${RESET}"
	fi
}


# Main function
function main(){
    if [ $# -eq 0 ]; then
        echo -e "${BOLD_RED}No arguments provided${RESET}"
		echo -e "${BOLD_RED}Try 'cleaner --help' for more information${RESET}"
		exit 1
    fi
    
    while [ $# -gt 0 ]; do
        case $1 in
            -h|--help)
                man
                ;;
            -t|--total)
                display_total
                ;;
            -u|--used)
                display_used
                ;;
            -a|--available)
                display_available
                ;;
            -l|--large)
                display_large
                ;;
            -c|--clean)
                clean
                ;;
            *)
                echo -e "${BOLD_RED}Unknown option: $1${RESET}"
                ;;
        esac
        shift
    done
}

# Execute main function with provided arguments
main "$@"
rm -rf ./titles ./values ./large_files 2>/dev/null