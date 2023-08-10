#!/bin/bash

function HELP(){
	echo -e "\nname\tdata_process"
	echo -e "description:\tTakes a currency change csv file and parse it into a json file\n"
	echo -e "usage:\t./data_process <csv file>\n"
}

if [ -z $1 ] || [ $# > 2 ]; then
	HELP
	exit
fi

echo lol
