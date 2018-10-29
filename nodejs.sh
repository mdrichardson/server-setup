#!/bin/bash
# This section installs nodejs

# Color variables
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`

# Update repositories

{
  sudo apt-get update &&
  echo -e "${GREEN}Repositories updated${RESET}"
} || {
  echo -e "${RED}Error updating repositories${RESET}"
  exit 0
}

# Install node.js

read -e -p "Install stable or from ppa (most up-to-date)? [s/ppa] " -i "ppa" nodeType

if [[ $nodeType = "s" || $nodeType = "S" ]]; then
{
  sudo apt-get -y install nodejs
  sudo apt-get -y install build-essential &&
  echo -e "${GREEN}Installed Node.js${RESET}"
} || {
  echo -e "${RED}Unable to install Node.js${RESET}"
  exit 0
}
elif [[ $nodeType = "ppa" || $nodeType = "PPA" ]]; then
{
  sudo apt-get -y install build-essential libssl-dev
  curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash
  export NVM_DIR="$HOME/.nvm"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm ls-remote
  read -e -p "Which version do you want to install? [x.x.x format]" nodeVersion
  nvm install $nodeVersion
  nvs use $nodeVersion
  echo -e "${GREEN}Installed Node.js${RESET}"
} || {
  echo -e "${RED}Unable to install Node.js${RESET}"
  exit 0
}
fi