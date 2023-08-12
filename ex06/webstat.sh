#!/bin/bash

# Number of command-line arguments
ARGS_COUNT=$#

# Color codes for formatting
RED_BOLD='\033[1;31m'
GREEN_BOLD='\033[1;32m'
YELLOW_BOLD='\033[1;33m'
BLUE_BOLD='\033[1;34m'
MAGENTA_BOLD='\033[1;35m'
CYAN_BOLD='\033[1;36m'
WHITE_BOLD='\033[1;37m'
RESET='\033[0m'

# Function to display a manual page
function manual(){
	clear
	echo -e "${GREEN_BOLD}NAME${RESET}"
	echo -e "\twebstat - website status checker"
	# ... (rest of the manual content)
	echo -en "\n:"
	stty -echo

	while IFS= read -r -n 1 char; do
		if [[ $char == $'q' ]]; then
			clear
			stty echo
			break
		fi
	done
	stty echo
	exit 0
}

# Check for arguments and provide help or manual
if [[ $ARGS_COUNT == 0 ]]; then
	echo -e "${RED_BOLD}Error: no arguments provided${RESET}"
	exit 1
fi

if [[ $ARGS_COUNT == 1 ]]; then
	if [[ $1 == "-h" || $1 == "--help" ]]; then
		manual
	fi
fi

# Function to print status message based on HTTP response code
function print_message(){
	arg=$1
	http_code=$(cat /tmp/webstat.txt)
	case $http_code in
		"200")
			echo -e "${GREEN_BOLD}$arg is up${RESET}"
			;;
		"000")
			echo -e "${RED_BOLD}$arg doesn't exist${RESET}"
			;;
		# ... (rest of the cases)
		*)
			echo $http_code
			;;
	esac
	echo -e "${RESET}"
}

# Loop over arguments and check websites
clear
for arg in "$@"; do
	if [[ $arg == "-f" || $arg == "--file" ]]; then
		if [[ $ARGS_COUNT == 1 ]]; then
			echo -e "${RED_BOLD}Error: no file provided${RESET}"
			exit 1
		fi
		if [[ -f $2 ]]; then
			while IFS= read -r line; do
				if [[ $line == "" || $line != "https://"* ]]; then
					continue
				fi
				echo -e "${BLUE_BOLD}Checking $line${RESET}"
				curl -k $line --output /dev/null --silent --head --write-out '%{http_code}\n' > /tmp/webstat.txt
				print_message $line
			done < $2
		else
			echo -e "${RED_BOLD}Error: file $2 does not exist\n${RESET}"
		fi
	elif [[ $arg != "" && $arg == "https://"* ]]; then
		echo -e "${BLUE_BOLD}Checking $arg${RESET}"
		curl -k $arg --output /dev/null --silent --head --write-out '%{http_code}\n' > /tmp/webstat.txt
		print_message $arg
	fi
done

echo -en "\n:"
while IFS= read -r -n 1 char; do
	if [[ $char == $'q' ]]; then
		clear
		stty echo
		break
	fi
done
stty echo
exit 0
