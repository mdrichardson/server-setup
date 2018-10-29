#!/bin/bash
# This is my interactive bash script for setting up a Ubuntu/Apache server on an Amazon EC2 instance
# Note: The bracketed format allows for pseudo-try/catch

# Color variables
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`

SOURCE="$( cd "$(dirname "$0")" ; pwd -P )"

# Run user-ssh-firewall.sh

read -e -p "Create new user, give appropriate access, and enable ssh? [y/n] " -i "y" userScript

if [[ $userScript = "Y" || $userScript = "y" ]]; then
  bash "${SOURCE}/user-ssh-firewall.sh"
else
  echo -e "${RED}Skipping user/ssh/firewall setup...${RESET}"
fi

# Install Node.js

read -e -p "Install Node.js? [y/n] " -i "y" nodeJs

if [[ $nodeJs = "Y" || $nodeJs = "y" ]]; then
  bash "${SOURCE}/nodejs.sh"
else
  echo -e "${RED}Skipping Node.js install...${RESET}"
fi

# Install postgres

read -e -p "Install PostgreSQL? [y/n] " -i "n" postgresql

if [[ $postgresql = "Y" || $postgresql = "y" ]]; then
  bash "${SOURCE}/postgresql.sh"
else
  echo -e "${RED}Skipping Postgres install...${RESET}"
fi

# Add website

read -e -p "Setup New Website? [y/n] " -i "y" website

if [[ $website = "Y" || $website = "y" ]]; then
  bash "${SOURCE}/new-website.sh"
else
  echo -e "${RED}Skipping Website setup...${RESET}"
fi

# Add additional website

read -e -p "Setup Additional Website? [y/n] " -i "y" website

if [[ $website = "Y" || $website = "y" ]]; then
  bash "${SOURCE}/new-website.sh"
else
  echo -e "${RED}Skipping Website setup...${RESET}"
fi

