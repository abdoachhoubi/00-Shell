#!/bin/bash

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PINK='\033[0;35m'
CYAN='\033[0;36m'
ORANGE='\033[0;91m'
VIOLET='\033[0;92m'
RESET='\033[0m'

# User input
INPUT=""
PASS=""
FILE_NAME="./pass.txt"

# Welcome message
WELCOME_MESSAGE="\\n██████╗░░█████╗░░██████╗░██████╗░██████╗░███████╗███╗░░██╗\n\
██╔══██╗██╔══██╗██╔════╝██╔════╝██╔════╝░██╔════╝████╗░██║\n\
██████╔╝███████║╚█████╗░╚█████╗░██║░░██╗░█████╗░░██╔██╗██║\n\
██╔═══╝░██╔══██║░╚═══██╗░╚═══██╗██║░░╚██╗██╔══╝░░██║╚████║\n\
██║░░░░░██║░░██║██████╔╝██████╔╝╚██████╔╝███████╗██║░╚███║\n\
╚═╝░░░░░╚═╝░░╚═╝╚═════╝░╚═════╝░░╚═════╝░╚══v1.0╝╚═╝░░╚══╝\n\
\n${YELLOW}passgen v1.0\n\n"

# Display welcome message
function DISPLAY_MESSAGE() {
    # clear
    echo -e "${GREEN}${WELCOME_MESSAGE}${RESET}"
}

function SHOW_COMMANDS() {
    echo -e "\
	\n\t${GREEN}GEN:${RESET}\tGenerates a new password\n\
	\t${GREEN}SHOW:${RESET}\tReveals the newely generated password\n\
	\t${GREEN}SAVE:${RESET}\tSaves the password to a file\n\
	\t${GREEN}EXIT:${RESET}\tExit passgen\n\
	\t${GREEN}HELP:${RESET}\tShows this message\n\
    "
}

function PROMPT() {
    echo -en "${GREEN}Enter your command${RESET}: "
    read INPUT
}

#  generate a new strong password (at least 16 chars, contains at least: 1 uppercase, 1 lowercase, 1 number, 1 special char)
function GEN() {
    PASS=$(openssl rand -base64 48 | cut -c1-16)
    echo -e "\tPassword generated successfully! 🎉"
}

function SHOW() {
    echo -e "\tYour password is:\t${GREEN}${PASS}${RESET}"
}

function SAVE() {
    echo -ne "\n${BLUE}Enter the file name where you'd like to save your password (./pass.txt)${RESET}: "
    read FILE_NAME
    if [[ -z "$FILE_NAME" ]]; then
        FILE_NAME="./pass.txt"
        elif [[ -e "$FILE_NAME" ]]; then
        echo -e "${RED}File already exists!\n${RESET}"
        echo -n "${BLUE}Do you want to overwrite it? (y/n) default (y)${RESET}: "
        read OVERWRITE
        if [[ $OVERWRITE == "y" ]] || [[ -z $OVERWRITE ]]; then
            echo -e "${RED}Overwriting file...${RESET}"
            echo -e "${PASS}" > $FILE_NAME
            echo -e "${GREEN}File saved successfully! 🎉\n${RESET}"
            return
        else
            echo -e "${RED}Aborting...\n${RESET}"
            return
        fi
    fi
    echo -e "${PASS}" > $FILE_NAME
    echo -e "${GREEN}\tFile saved successfully!\n${RESET}"
}

function EXIT() {
    echo -e "${RED}\tExiting...${RESET}"
    exit 0
}

# Error message
function ERROR() {
    echo -e "${RED}\tInvalid command!${RESET}"
}

# The CLI loop
function CLI() {
    
    DISPLAY_MESSAGE
    while true; do
        PROMPT
        shopt -s nocasematch
        if [[ "${INPUT}" == "GEN" ]]; then
            GEN
            elif [[ "${INPUT}" == "SHOW" ]]; then
            SHOW
            elif [[ "${INPUT}" == "SAVE" ]]; then
            SAVE
            elif [[ "${INPUT}" == "HELP" ]]; then
            SHOW_COMMANDS
            elif [[ "${INPUT}" == "EXIT" ]]; then
            EXIT
        else
            ERROR
        fi
    done
}

# CLI
CLI