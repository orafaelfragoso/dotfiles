#!/usr/bin/env bash

SYSTEM=$(uname -s)
GIT_EMAIL=""
GIT_USERNAME=""
GIT_NAME=""

if [ ! -d "$HOME/.dotfiles" ]; then
	printf "\nInstalling dotfiles for the first time 🚀\n"
	curl -L -o dotfiles.zip https://github.com/orafaelfragoso/dotfiles/archive/master.zip
	unzip -j -o -q dotfiles.zip -d $HOME/.dotfiles
	cd "$HOME/.dotfiles"
else
	echo "\n🚫 dotfiles are already installed."
fi

function config() {
	printf "\033[0;32m$SYSTEM\033[0m\n"
	printf "\033[1;32m💻 $1 detected. Proceeding with install.\033[0m\n"

	read -p "Enter Your Github E-mail: " GIT_EMAIL
	read -p "Enter Your Github Username: " GIT_USERNAME
	read -p "Enter Your Name (Ex: Rafael Fragoso): " GIT_NAME
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
