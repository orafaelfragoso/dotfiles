#!/usr/bin/env bash

SYSTEM=$(uname -s)
GIT_EMAIL=""
GIT_USERNAME=""
GIT_NAME=""

if [ -d "$HOME/.dotfiles" ]; then
	echo "\nFound dotfiles directory."
	echo "\nCreating backup before continuing."
	mv $HOME/.dotfiles $HOME/.dotfiles.backup
	echo "\nFinished backup resuming install."
fi

printf "\nInstalling dotfiles 🚀\n"
curl -L -o dotfiles.zip https://github.com/orafaelfragoso/dotfiles/archive/master.zip
unzip dotfiles.zip
cp -r ./dotfiles-master $HOME/.dotfiles
rm -rf ./dotfiles-master ./dotfiles.zip
cd "$HOME/.dotfiles"

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
