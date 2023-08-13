#!/bin/bash

RED_BOLD="\033[1;31m"
GREEN_BOLD="\033[1;32m"
YELLOW_BOLD="\033[1;33m"
BLUE_BOLD="\033[1;34m"
MAGENTA_BOLD="\033[1;35m"
CYAN_BOLD='\033[1;36m'
WHITE_BOLD='\033[1;37m'
RESET='\033[0m'

# echo $SPLIT
ps > infile

PROCESS=()

# create an array of processes excluding the two first lines
while read line
do
	PROCESS+=("$line")
done < <(tail -n +3 infile)
# done < infile

CHIOCE=-1


function print_list()
{
	echo -e $RED_BOLD"PID\tCMD"$RESET
	for i in "${PROCESS[@]}"
	do
		echo -e $RED_BOLD$i$RESET | awk '{print $1}' > /tmp/proc.txt
		cat -n /tmp/proc.txt
		echo -e $RED_BOLD$i$RESET | awk '{print $4}'
	done
}

function header_art()
{
	echo -e $RED_BOLD"._____________________________________________."$RESET
	echo -e $RED_BOLD"|  ┏━┳━┳━┳━┓                                  |"$RESET
	echo -e $RED_BOLD"|  ┃╋┃╋┃┃┃┏┛ proc v1.0                        |"$RESET
	echo -e $RED_BOLD"|  ┃┏┫┓┫┃┃┗┓ Process manager                  |"$RESET
	echo -e $RED_BOLD"|  ┗┛┗┻┻━┻━┛ List and kill processes          |"$RESET
	echo -e $RED_BOLD"|_____________________________________________|\n"$RESET

}

function print_menu()
{
	echo -e $GREEN_BOLD"1. List processes"$RESET
	echo -e $GREEN_BOLD"2. Kill process"$RESET
	echo -e $GREEN_BOLD"3. Exit"$RESET
}

function infinit_loop()
{
	print_menu
	while true
	do
		echo -en $WHITE_BOLD"Enter your choice: "$RESET
		read CHOICE
		case $CHOICE in
			1) print_list;;
			2) 
				echo -en $WHITE_BOLD"Enter the PID of the process to kill: "$RESET
				read PID
				kill $PID;;
			3) exit 0;;
			*) echo "Invalid choice";;
		esac
	done
}


clear
header_art
infinit_loop
