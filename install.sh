#!/usr/bin/env bash

SYSTEM=$(uname -s)
GIT_EMAIL=""
GIT_NAME=""

function config() {
	printf "\033[0;32m$SYSTEM\033[0m\n"
	printf "\033[1;32m$1 detected. Proceeding with install.\033[0m\n"

	read -p "Enter Your Github E-mail: " GIT_EMAIL
	read -p "Enter Your Name (Ex: Rafael Fragoso): " GIT_NAME

	chmod +x ./bin/macos.sh
	chmod +x ./bin/ubuntu.sh
}

case "$SYSTEM" in
	Linux*)     
		# todo: Detect different versions of Linux
		config "Linux"
		;;
	Darwin*)    
		config "MacOS"
		. ./bin/macos.sh
		;;
	CYGWIN*)    
		config "CYGWIN"
		;;
	*)          
		printf "Unknown operating system. Please find your operating system file inside the 'bin' folder in this project and run the script manually.\n"
esac
