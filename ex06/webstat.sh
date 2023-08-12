#!/bin/bash

ARGS_COUNT=$#
RED_BOLD='\033[1;31m'
GREEN_BOLD='\033[1;32m'
YELLOW_BOLD='\033[1;33m'
BLUE_BOLD='\033[1;34m'
MAGENTA_BOLD='\033[1;35m'
CYAN_BOLD='\033[1;36m'
WHITE_BOLD='\033[1;37m'
RESET='\033[0m'


function manual(){
	# a man page like function
	clear
	echo -e "${GREEN_BOLD}NAME${RESET}"
	echo -e "\twebstat - website status checker"
	echo -e "${GREEN_BOLD}SYNOPSIS${RESET}"
	echo -e "\twebstat [OPTION]... [FILE]..."
	echo -e "${GREEN_BOLD}DESCRIPTION${RESET}"
	echo -e "\tThis script checks the availability of a list of websites and notifies you if any of them are down."
	echo -e "\tIf no arguments are provided, the script will exit with an error message."
	echo -e "\tIf the first argument is -h or --help, the script will display a manual page."
	echo -e "\tIf the first argument is -f or --file, the script will read the list of websites from the file provided as the second argument."
	echo -e "${GREEN_BOLD}OPTIONS${RESET}"
	echo -e "\t-h, --help"
	echo -e "\t\tDisplay a manual page and exit."
	echo -e "\t-f, --file"
	echo -e "\t\tRead the list of websites from the file provided as the second argument."

	echo -en "\n:"
	stty -echo

	while IFS= read -r -n 1 char; do
        # Break the loop if the user presses Enter
        if [[ $char == $'q' ]]; then
            clear
			stty echo
            break
        fi
    done
	stty echo
	exit 0
}

if [[ $ARGS_COUNT == 0 ]]; then
	echo -e "${RED_BOLD}Error: no arguments provided${RESET}"
	exit 1
fi

if [[ $ARGS_COUNT == 1 ]]; then
	if [[ $1 == "-h" || $1 == "--help" ]]; then
		manual
	fi
fi

function print_mesage(){
	arg=$1
	if [[ $(cat /tmp/webstat.txt) == "200" ]]; then
			echo -e "${GREEN_BOLD}$arg is up${RESET}"
		elif [[ $(cat /tmp/webstat.txt) == "000" ]]; then
			echo -e "${RED_BOLD}$arg doesn't exist${RESET}"
		elif [[ $(cat /tmp/webstat.txt) == "301" ]]; then
			echo -e "${YELLOW_BOLD}$arg has been moved permanently${RESET}"
		elif [[ $(cat /tmp/webstat.txt) == "302" ]]; then
			echo -e "${YELLOW_BOLD}$arg has been moved temporarily${RESET}"
		elif [[ $(cat /tmp/webstat.txt) == "400" ]]; then
			echo -e "${RED_BOLD}$arg is a bad request${RESET}"
		elif [[ $(cat /tmp/webstat.txt) == "401" ]]; then
			echo -e "${RED_BOLD}$arg is unauthorized${RESET}"
		elif [[ $(cat /tmp/webstat.txt) == "403" ]]; then
			echo -e "${RED_BOLD}$arg is forbidden${RESET}"
		elif [[ $(cat /tmp/webstat.txt) == "404" ]]; then
			echo -e "${RED_BOLD}$arg is not found${RESET}"
		elif [[ $(cat /tmp/webstat.txt) == "500" ]]; then
			echo -e "${RED_BOLD}$arg is an internal server error${RESET}"
		elif [[ $(cat /tmp/webstat.txt) == "502" ]]; then
			echo -e "${RED_BOLD}$arg is a bad gateway${RESET}"
		elif [[ $(cat /tmp/webstat.txt) == "503" ]]; then
			echo -e "${RED_BOLD}$arg is a service unavailable${RESET}"
		elif [[ $(cat /tmp/webstat.txt) == "504" ]]; then
			echo -e "${RED_BOLD}$arg is a gateway timeout${RESET}"
		else
			echo $(cat /tmp/webstat.txt)
		fi
		echo -e "${RESET}"
}

#  loop over the arguments and run curl command for each one
clear
for arg in "$@"; do
	if [[ $arg == "-f" || $arg == "--file" ]]; then
		if [[ $ARGS_COUNT == 1 ]]; then
			echo -e "${RED_BOLD}Error: no file provided${RESET}"
			exit 1
		fi
		# if [[ $ARGS_COUNT >= 2 ]]; then
			if [[ -f $2 ]]; then
				while IFS= read -r line; do
					if [[ $line == "" ]]; then
						continue
					fi
					if [[ $line != "https://"* ]]; then
						continue
					fi
					echo -e "${BLUE_BOLD}Checking $line${RESET}"
					curl -k $line --output /dev/null --silent --head --write-out '%{http_code}\n' > /tmp/webstat.txt
					print_mesage $line
				done < $2
			else
				echo -e "${RED_BOLD}Error: file $2 does not exist\n${RESET}"
			fi
		# fi
	elif [[ $arg != "" && $arg == "https://"* ]]; then
		echo -e "${BLUE_BOLD}Checking $arg${RESET}"
		curl -k $arg --output /dev/null --silent --head --write-out '%{http_code}\n' > /tmp/webstat.txt
		print_mesage $arg
	fi
done

echo -en "\n:"
while IFS= read -r -n 1 char; do
    # Break the loop if the user presses Enter
    if [[ $char == $'q' ]]; then
        clear
		stty echo
        break
    fi
done
stty echo
exit 0