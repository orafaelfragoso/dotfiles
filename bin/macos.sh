#!/usr/bin/env bash

NUMBER_OF_STEPS=4

# Questions
question() {
  read -p "$(echo -e "\n\b")$1 [Y/n]: " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    NUMBER_OF_STEPS=$((NUMBER_OF_STEPS + 1))
    eval "$2"=1
  fi
}

# Necessary tools to compile and install other tools
command_line_tools() {
  printf "\n\033[0;32m[1|$NUMBER_OF_STEPS] Installing command line tools\033[0m"
}

homebrew() {
  printf "\n\033[0;32m[2|$NUMBER_OF_STEPS] Installing Homebrew\033[0m"
}

git() {
  printf "\n\033[0;32m[3|$NUMBER_OF_STEPS] Installing Git\033[0m"
}

sshkeys() {
  printf "\n\033[0;32m[4|$NUMBER_OF_STEPS] Generating SSH keys for Github and Bitbucket\033[0m"
}

# Programming Languages
# Databases
# Development Software
# User Preferences

read -p "Do you wish to install everything? Say $(echo -e "\033[1;31mno\033[0m") if you want a custom install: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  printf "\nInstalling eveyrhing..."
  command_line_tools
  homebrew
  git
  sshkeys
else
  NUMBER_OF_STEPS=0
  question "Install Command-line Tools?" "INSTALL_COMMAND_LINE_TOOLS"
  question "Install Homebrew?" "INSTALL_HOMEBREW"
  question "Install Git?" "INSTALL_GIT"
  question "Generate SSH keys" "GENERATE_SSH_KEYS"

  if [[ ! -z "$INSTALL_COMMAND_LINE_TOOLS" ]] || [[ "$INSTALL_COMMAND_LINE_TOOLS" =~ (Y|y|1) ]]; then
    command_line_tools
  fi

  if [[ ! -z "$INSTALL_HOMEBREW" ]] || [[ "$INSTALL_HOMEBREW" =~ (Y|y|1) ]]; then
    homebrew
  fi

  if [[ ! -z "$INSTALL_GIT" ]] || [[ "$INSTALL_GIT" =~ (Y|y|1) ]]; then
    git
  fi

  if [[ ! -z "$GENERATE_SSH_KEYS" ]] || [[ "$GENERATE_SSH_KEYS" =~ (Y|y|1) ]]; then
    sshkeys
  fi
fi
