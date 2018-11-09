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
  read -e -p "Which version do you want to install? [8, 10, 11, 12]" nodeVersion
  cd ~
  sudo apt-get -y install curl
  curl -sL https://deb.nodesource.com/setup_${nodeVersion}.x | sudo -E bash -
  sudo apt-get install nodejs
  nodejs -v &&
  echo -e "${GREEN}Installed Node.js${RESET}"
} || {
  echo -e "${RED}Unable to install Node.js${RESET}"
  exit 0
}
fi