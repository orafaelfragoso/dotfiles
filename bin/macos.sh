#!/usr/bin/env bash

NUMBER_OF_STEPS=19

# Questions
question() {
  read -p "$(echo -e "\n\b")$1 [Y/n]: " -n 1 -r
  if [[ $REPLY =~ ^[Yy]$ ]]; then
    NUMBER_OF_STEPS=$((NUMBER_OF_STEPS + 1))
    eval "$2"=1
  fi
}

# Necessary tools to compile and install other tools
command_line_tools_install() {
  printf "\n\033[0;32m[1|$NUMBER_OF_STEPS] Installing command line tools\033[0m"
  if hash $(xcode-select -p) 0>/dev/null; then
    printf "\nCommand-line tools is already installed. Skipping."
    return
  fi

  xcode-select --install
  . ~/.bashrc
}

homebrew_install() {
  printf "\n\033[0;32m[2|$NUMBER_OF_STEPS] Installing Homebrew\033[0m"
  if hash brew 2>/dev/null; then
    printf "\nHomebrew is already installed. Skipping."
    return
  fi

  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
  . ~/.bashrc
}

git_install() {
  printf "\n\033[0;32m[3|$NUMBER_OF_STEPS] Installing Git\033[0m"
  if hash git 2>/dev/null; then
    printf "\nGit is already installed. Skipping."
    return
  fi

  brew install git
  git config --global user.name "$GIT_NAME"
  git config --global user.email "$GIT_EMAIL"
}

sshkeys_install() {
  printf "\n\033[0;32m[4|$NUMBER_OF_STEPS] Generating SSH keys for Github and Bitbucket\033[0m"
  local SSH_PATH=~/.ssh
  local GITHUB_KEY=$SSH_PATH/id_rsa
  local BITBUCKET_KEY=$SSH_PATH/$GIT_USERNAME
  local CONFIG=$SSH_PATH/config

  if [ -f "$GITHUB_KEY" ]; then
    printf "\nGithub key already exists. Skipping."
  else
    printf "\nGenerating Github keys."
    
    ssh-keygen -t rsa -b 4096 -C "$GIT_EMAIL" -N ""
  fi

  if [  -f "$BITBUCKET_KEY" ]; then
    printf "\nBitbucket key already exists. Skipping."
  else
    printf "\nGenerating Bitbucket keys."

    ssh-keygen -f ~/.ssh/$GIT_USERNAME -N ""
  fi

  if [ -f "$CONFIG" ]; then
    printf "\nconfig file already exists. Skipping."
  else
    printf "\nConfiguring SSH keys"

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
  printf "\n\033[0;32m[5|$NUMBER_OF_STEPS] Installing ZSH\033[0m"
  if [ -x "$(command -v zsh)" ]; then
    printf "\nZSH is already installed. Skipping."
    return
  fi

  brew install zsh zsh-completions
  chsh -s /bin/zsh
  sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
}

# Programming Languages
asdf_install() {
  printf "\n\033[0;32m[6|$NUMBER_OF_STEPS] Installing asdf\033[0m"
  if [ -x "$(command -v asdf)" ]; then
    printf "\nasdf is already installed. Skipping."
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
  printf "\n\033[0;32m[7|$NUMBER_OF_STEPS] Installing NodeJS\033[0m"
  if [ -x "$(command -v node)" ]; then
    printf "\nNodeJS is already installed. Skipping."
    return
  fi

  asdf plugin-add nodejs
  bash ~/.asdf/plugins/nodejs/bin/import-release-team-keyring
  asdf install nodejs 12.2.0
  asdf global nodejs 12.2.0
}

ruby_install() {
  printf "\n\033[0;32m[8|$NUMBER_OF_STEPS] Installing Ruby\033[0m"
  if [ -x "$(command -v ruby)" ]; then
    printf "\nRuby is already installed. Skipping."
    return
  fi

  asdf plugin-add ruby
  asdf install ruby 2.6.3
  asdf global ruby 2.6.3
}

# Databases
mysql_install() {
  printf "\n\033[0;32m[9|$NUMBER_OF_STEPS] Installing MySQL\033[0m"
  if hash mysql 2>/dev/null; then
    printf "\nMySQL is already installed. Skipping."
    return
  fi

  brew install mysql
}

postgresql_install() {
  printf "\n\033[0;32m[10|$NUMBER_OF_STEPS] Installing PostgreSQL\033[0m"
  if hash psql 2>/dev/null; then
    printf "\nPostgreSQL is already installed. Skipping."
    return
  fi

  brew install postgres
}

# Development Software
docker_install() {
  printf "\n\033[0;32m[11|$NUMBER_OF_STEPS] Installing Docker\033[0m"
  if [ -x "$(command -v docker)" ]; then
    printf "\nDocker is already installed. Skipping."
    return
  fi

  brew cask install docker
}

vim_install() {
  printf "\n\033[0;32m[12|$NUMBER_OF_STEPS] Installing Vim and MacVim\033[0m"

  brew install vim
  brew install macvim
}

vscode_install() {
  printf "\n\033[0;32m[13|$NUMBER_OF_STEPS] Installing Visual Studio Code\033[0m"
  if [ -x "$(command -v code)" ]; then
    printf "\nVisual Studio Code is already installed. Skipping."
    return
  fi

  brew cask install visual-studio-code
}

tmux_install() {
  printf "\n\033[0;32m[14|$NUMBER_OF_STEPS] Installing Tmux\033[0m"
  if tmux -V &>/dev/null; then
    printf "\nTmux is already installed. Skipping."
    return
  fi

  brew install tmux
}

iterm2_install() {
  printf "\n\033[0;32m[15|$NUMBER_OF_STEPS] Installing Tmux\033[0m"
  if brew info brew-cask &>/dev/null; then
    printf "\niTerm2 is already installed. Skipping."
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
  printf "\nInstalling everything..."
  command_line_tools_install
  homebrew_install
  git_install
  sshkeys_install
  zsh_install
  asdf_install
  nodejs_install
  ruby_install
  mysql_install
  postgresql_install
  docker_install
  vim_install
  vscode_install
  tmux_install
  iterm2_install
else
  NUMBER_OF_STEPS=0
  question "Install Command-line Tools?" "INSTALL_COMMAND_LINE_TOOLS"
  question "Install Homebrew?" "INSTALL_HOMEBREW"
  question "Install Git?" "INSTALL_GIT"
  question "Generate SSH keys" "GENERATE_SSH_KEYS"
  question "Install ZSH?" "INSTALL_ZSH"
  question "Install asdf?" "INSTALL_ASDF"
  question "Install NodeJS?" "INSTALL_NODEJS"
  question "Install Ruby?" "INSTALL_RUBY"
  question "Install MySQL?" "INSTALL_MYSQL"
  question "Install PostgreSQL?" "INSTALL_POSTGRES"
  question "Install Docker?" "INSTALL_DOCKER"
  question "Install Vim?" "INSTALL_VIM"
  question "Install VSCode?" "INSTALL_VSCODE"
  question "Install Tmux?" "INSTALL_TMUX"
  question "Install iTerm2?" "INSTALL_ITERM"

  if [[ ! -z "$INSTALL_COMMAND_LINE_TOOLS" ]] || [[ "$INSTALL_COMMAND_LINE_TOOLS" =~ (Y|y|1) ]]; then
    command_line_tools_install
  fi

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

  if [[ ! -z "$INSTALL_MYSQL" ]] || [[ "$INSTALL_MYSQL" =~ (Y|y|1) ]]; then
    mysql_install
  fi

  if [[ ! -z "$INSTALL_POSTGRES" ]] || [[ "$INSTALL_POSTGRES" =~ (Y|y|1) ]]; then
    postgresql_install
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
