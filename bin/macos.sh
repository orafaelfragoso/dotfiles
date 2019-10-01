#!/usr/bin/env bash

NUMBER_OF_STEPS=19
STEP=1

# Questions
question() {
  read -p "$(echo -e "\n\b")$1 [Y/n]: " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    NUMBER_OF_STEPS=$((NUMBER_OF_STEPS + 1))
    eval "$2"=1
  fi
}

console() {
  case $2 in
    0*)
      printf "\n\033[0;32m[$STEP|$NUMBER_OF_STEPS] $1\033[0m\n"
      ;;
    1*)
      printf "\n$1\n"
      ;;
    *)
      printf "\n\033[0;32m[$STEP|$NUMBER_OF_STEPS] $1\033[0m\n"
  esac
}

# Necessary tools to compile and install other tools
# HOMEBREW ALREADY INSTALLS CLI TOOLS
command_line_tools_install() {
  console "Installing command line tools"

  if hash $(xcode-select -p) 0>/dev/null; then
    printf "\nCommand-line tools is already installed. Skipping."
    return
  fi

  xcode-select --install
  . ~/.bashrc
}

homebrew_install() {
  console "Installing Homebrew"

  if hash brew 2>/dev/null; then
    console "Homebrew is already installed. Skipping." 1
    return
  fi

  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  . ~/.bashrc
}

git_install() {
  console "Installing Git"

  if hash git 2>/dev/null; then
    console "Git is already installed. Skipping." 1
    return
  fi

  brew install git
  git config --global user.name "$GIT_NAME"
  git config --global user.email "$GIT_EMAIL"
}

sshkeys_install() {
  console "Generating SSH keys for Github and Bitbucket"

  local SSH_PATH=$HOME/.ssh
  local GITHUB_KEY=$SSH_PATH/id_rsa
  local BITBUCKET_KEY=$SSH_PATH/$GIT_USERNAME
  local CONFIG=$SSH_PATH/config

  if [ -f "$GITHUB_KEY" ]; then
    console "Github key already exists. Skipping." 1
  else
    console "Generating Github keys." 1
    
    ssh-keygen -t rsa -f "$SSH_PATH/id_rsa" -b 4096 -C "$GIT_EMAIL" -q -N ""
  fi

  if [  -f "$BITBUCKET_KEY" ]; then
    console "Bitbucket key already exists. Skipping." 1
  else
    console "Generating Bitbucket keys." 1

    ssh-keygen -f ~/.ssh/$GIT_USERNAME -q -N ""
  fi

  if [ -f "$CONFIG" ]; then
    console "config file already exists. Skipping." 1
  else
    console "Configuring SSH keys" 1

    echo "Host github.com
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_rsa

Host bitbucket.org
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/$GIT_USERNAME" >> ~/.ssh/config

    eval "$(ssh-agent -s)"
    ssh-add -K ~/.ssh/id_rsa
    ssh-add ~/.ssh/$GIT_USERNAME
  fi
}

zsh_install() {
  console "Installing ZSH"

  if [ -x "$(command -v zsh)" ]; then
    console "ZSH is already installed. Skipping." 1
  else 
    brew install zsh zsh-completions
  fi

  # Change to ZSH
  chsh -s /bin/zsh

  if [ -d "$HOME/.oh-my-zsh" ]; then
    console "oh-my-zsh is already installed. Skipping." 1
  else
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
  fi
}

# Programming Languages
asdf_install() {
  console "Installing asdf"

  if [ -x "$(command -v asdf)" ]; then
    console "asdf is already installed. Skipping." 1
    return
  fi

  brew install \
    coreutils automake autoconf openssl \
    libyaml readline libxslt libtool unixodbc \
    unzip curl gpg

  brew install asdf

  echo -e '\n. /usr/local/opt/asdf/asdf.sh' >> ~/.zshrc
  echo -e '\n. /usr/local/opt/asdf/asdf.sh' >> ~/.bashrc
  . ~/.bashrc
}

nodejs_install() {
  console "Installing NodeJS"

  if [ -x "$(command -v node)" ]; then
    console "NodeJS is already installed. Skipping." 1
    return
  fi

  asdf plugin-add nodejs
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
  asdf install nodejs 12.2.0
  asdf global nodejs 12.2.0
}

ruby_install() {
  console "Installing Ruby"

  # Ruby is already installed on macos, override it.
  # if [ -x "$(command -v ruby)" ]; then
  #   printf "\nRuby is already installed. Skipping."
  #   return
  # fi

  asdf plugin-add ruby
  asdf install ruby 2.6.3
  asdf global ruby 2.6.3
}

# Development Software
docker_install() {
  console "Installing Docker"

  if [ -x "$(command -v docker)" ]; then
    console "Docker is already installed. Skipping." 1
    return
  fi

  brew cask install docker
}

vim_install() {
  console "Installing Vim and MacVim"

  brew install vim
  brew install macvim
}

vscode_install() {
  console "Installing Visual Studio Code"

  if [ -x "$(command -v code)" ]; then
    console "Visual Studio Code is already installed. Skipping." 1
    return
  fi

  brew cask install visual-studio-code
}

tmux_install() {
  console "Installing Tmux"

  if tmux -V &>/dev/null; then
    console "Tmux is already installed. Skipping." 1
    return
  fi

  brew install tmux
}

iterm2_install() {
  console "Installing Tmux"

  if brew info brew-cask &>/dev/null; then
    console "iTerm2 is already installed. Skipping." 1
    return
  fi

  brew cask install iterm2
}

# User Preferences
vimfiles_install() {
  echo
}

tmuxfiles_install() {
  echo
}

vscodefiles_install() {
  echo
}

iterm2files_install() {
  echo
}

# Start installation
read -p "Do you wish to install everything? Say $(echo -e "\033[1;31mno\033[0m") if you want a custom install: " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
  console "Installing everything"
  # command_line_tools_install
  homebrew_install
  STEP=$((STEP + 1))
  git_install
  STEP=$((STEP + 1))
  sshkeys_install
  STEP=$((STEP + 1))
  zsh_install
  STEP=$((STEP + 1))
  asdf_install
  STEP=$((STEP + 1))
  nodejs_install
  STEP=$((STEP + 1))
  ruby_install
  STEP=$((STEP + 1))
  docker_install
  STEP=$((STEP + 1))
  vim_install
  STEP=$((STEP + 1))
  vscode_install
  STEP=$((STEP + 1))
  tmux_install
  STEP=$((STEP + 1))
  iterm2_install
  STEP=$((STEP + 1))
else
  NUMBER_OF_STEPS=0
  # question "Install Command-line Tools?" "INSTALL_COMMAND_LINE_TOOLS"
  question "Install Homebrew?" "INSTALL_HOMEBREW"
  question "Install Git?" "INSTALL_GIT"
  question "Generate SSH keys" "GENERATE_SSH_KEYS"
  question "Install ZSH?" "INSTALL_ZSH"
  question "Install asdf?" "INSTALL_ASDF"
  question "Install NodeJS?" "INSTALL_NODEJS"
  question "Install Ruby?" "INSTALL_RUBY"
  question "Install Docker?" "INSTALL_DOCKER"
  question "Install Vim?" "INSTALL_VIM"
  question "Install VSCode?" "INSTALL_VSCODE"
  question "Install Tmux?" "INSTALL_TMUX"
  question "Install iTerm2?" "INSTALL_ITERM"

  # if [[ ! -z "$INSTALL_COMMAND_LINE_TOOLS" ]] || [[ "$INSTALL_COMMAND_LINE_TOOLS" =~ (Y|y|1) ]]; then
  #   command_line_tools_install
  # fi

  if [[ ! -z "$INSTALL_HOMEBREW" ]] || [[ "$INSTALL_HOMEBREW" =~ (Y|y|1) ]]; then
    homebrew_install
  fi

  if [[ ! -z "$INSTALL_GIT" ]] || [[ "$INSTALL_GIT" =~ (Y|y|1) ]]; then
    git_install
  fi

  if [[ ! -z "$GENERATE_SSH_KEYS" ]] || [[ "$GENERATE_SSH_KEYS" =~ (Y|y|1) ]]; then
    sshkeys_install
  fi

  if [[ ! -z "$INSTALL_ZSH" ]] || [[ "$INSTALL_ZSH" =~ (Y|y|1) ]]; then
    zsh_install
  fi

  if [[ ! -z "$INSTALL_ASDF" ]] || [[ "$INSTALL_ASDF" =~ (Y|y|1) ]]; then
    asdf_install
  fi

  if [[ ! -z "$INSTALL_NODEJS" ]] || [[ "$INSTALL_NODEJS" =~ (Y|y|1) ]]; then
    nodejs_install
  fi

  if [[ ! -z "$INSTALL_RUBY" ]] || [[ "$INSTALL_RUBY" =~ (Y|y|1) ]]; then
    ruby_install
  fi

  if [[ ! -z "$INSTALL_DOCKER" ]] || [[ "$INSTALL_DOCKER" =~ (Y|y|1) ]]; then
    docker_install
  fi

  if [[ ! -z "$INSTALL_VIM" ]] || [[ "$INSTALL_VIM" =~ (Y|y|1) ]]; then
    vim_install
  fi

  if [[ ! -z "$INSTALL_VSCODE" ]] || [[ "$INSTALL_VSCODE" =~ (Y|y|1) ]]; then
    vscode_install
  fi

  if [[ ! -z "$INSTALL_TMUX" ]] || [[ "$INSTALL_TMUX" =~ (Y|y|1) ]]; then
    tmux_install
  fi

  if [[ ! -z "$INSTALL_ITERM" ]] || [[ "$INSTALL_ITERM" =~ (Y|y|1) ]]; then
    iterm2_install
  fi
fi
