#!/bin/bash

# Global variable
password="whocaresabtencryption"

# Prompt
echo -n "username: "
read name

# Greeting
echo "Hello and welcome $name!"

# Playing around
if [ "$name" == "astro" ]; then
	echo -n "Password please ?_?: "
	read password
else
	echo "Have a good day!"
fi

if [ "$password" == "ortsa" ]; then
	echo "I'll take you to the next level"
	cd ../ex01
	echo "Enjoy hacking!"
elif [ "$password" != "whocaresabtencryption" ]; then
	echo "Incorrect password XD"
fi
