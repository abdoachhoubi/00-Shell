#!/bin/bash

# Color codes for formatting output
RED_BOLD="\033[1;31m"
ORANGE_BOLD="\033[1;33m"
GREEN_BOLD="\033[1;32m"
YELLOW_BOLD="\033[1;33m"
BLUE_BOLD="\033[1;34m"
MAGENTA_BOLD="\033[1;35m"
RESET="\033[0m"

# Store command line arguments in variables
INFILE=$1
OUTFILE=$2

# Function to display manual/help information
function MANUAL() {
    # Print NAME section
    echo -e "$GREEN_BOLD""NAME""$RESET"
    echo -e "\t$0 - Convert CSV file to JSON"
    echo ""

    # Print SYNOPSIS section
    echo -e "$GREEN_BOLD""SYNOPSIS""$RESET"
    echo -e "\t$0 <infile> <outfile>"
    echo ""

    # Print DESCRIPTION section
    echo -e "$GREEN_BOLD""DESCRIPTION""$RESET"
    echo -e "\tThis script reads a CSV file and converts its contents into a JSON file."
    echo ""

    # Print OPTIONS section
    echo -e "$GREEN_BOLD""OPTIONS""$RESET"
    echo -e "\t<infile>"
    echo -e "\t\tThe input CSV file to be converted."
    echo ""
    echo -e "\t<outfile>"
    echo -e "\t\tThe output JSON file where the converted data will be stored."
    echo ""

    # Print EXAMPLE section
    echo -e "$BLUE_BOLD""EXAMPLE""$RESET"
    echo -e "\t$0 input.csv output.json"
    echo -en "\n:"
    
    # Read a single character without echoing it to the terminal
	stty -echo
	read -n 1 quit_input
	stty echo

	if [[ $quit_input == q || $quit_input == Q ]]; then
		clear
	    exit 0
	fi
}

# Check for help flag and display manual
if [ "$1" == "-h" -o "$1" == "--help" ]; then
	MANUAL
	exit 0
fi

# Check if correct number of arguments is provided
if [ $# -ne 2 ]; then
	echo -e "$RED_BOLD""Usage: $0 <infile> <outfile>""$RESET"
	exit 1
fi

# Check if input file exists
if [ ! -f "$INFILE" ]; then
	echo -e "$RED_BOLD""Error: $INFILE does not exist""$RESET"
	exit 1
fi

if [ "$OUTFILE" == "$INFILE" ]; then
	echo -e "$RED_BOLD""Error: outfile is the same as infile""$RESET"
	exit 1
fi

# Check if output file already exists
if [ -f "$OUTFILE" ]; then
	echo -e "$ORANGE_BOLD""Warning: $OUTFILE already exists""$RESET"
	echo -en "Overwrite? (y/n)"
	read -r OVERWRITE
	if [ "$OVERWRITE" == "y" ]; then
		rm -rf "$OUTFILE"
		touch "$OUTFILE"
	else
		exit 0
	fi
fi

# Begin JSON file with an opening square bracket
echo -e "[" > "$OUTFILE"
echo -e "$MAGENTA_BOLD""Converting $INFILE to $OUTFILE...""$RESET"

# Count the number of lines in the input file
LINES_COUNT=$(cat "$INFILE" | wc -l)

# Split the first line into an array of strings
IFS=',' read -r -a FIRST_LINE_ARRAY <<< "$(head -n 1 "$INFILE")"

# Loop over each line in the input file and generate JSON-like output
for (( i=2; i<=LINES_COUNT; i++ ))
do
	IFS=',' read -r -a LINE_ARRAY <<< "$(sed -n "$i"p "$INFILE")"
	JSON=""
	for (( j=0; j<${#FIRST_LINE_ARRAY[@]}; j++ ))
	do
		if [ "$JSON" != "" ]; then
			JSON="$JSON,"
		fi
		JSON="$JSON\"${FIRST_LINE_ARRAY[$j]}\":\"${LINE_ARRAY[$j]}\""
	done
	echo -n "{$JSON}" >> "$OUTFILE"
	if [ $i -ne $LINES_COUNT ]; then
		echo "," >> "$OUTFILE"
	else
		echo "" >> "$OUTFILE"
	fi
done

# End JSON file with a closing square bracket
echo -e "]" >> "$OUTFILE"

echo -e "$GREEN_BOLD""Conversion complete!""$RESET"
