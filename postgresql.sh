#!/bin/bash
# This section installs PostgreSQL

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

# Install PostgreSQL

{
  sudo apt-get -y install postgresql postgresql-contrib
  sudo update-rc.d postgresql enable &&
  echo -e "${GREEN}Installed PostgreSQL${RESET}"
} || {
  echo -e "${RED}Unable to install PostgreSQL${RESET}"
  exit 0
}

# Create new PostgreSQL user

read -e -p "Create new PostgreSQL user? [y/n] " -i "y" newUser
echo "When it asks you for a username, be sure to use your Ubuntu account name"

if [[ $newUser = "Y" || $newUser = "y" ]]; then
  sudo -u postgres createuser --interactive
  read -e -p "Enter the name of the PostgreSQL user you just created: " username
  sudo -u postgres createdb $username &&
  # The next line allows you to remotely connect to postgres. You may need to change the 9.5 to the actual postgres version you have
  # When setting up PGAdmin, use:
    # Connection:
      # Host: localhost
      # Port: 5432
      # Username: Username entered in this script
    # SSH Tunnel
      # Use: yes
      # Tunnel host: IP of server
      # Port: 22
      # Username: Your Ubuntu username
      # Auth: Identity File
      # Identity File: Use the private key .pem file
  echo "host    ${username}    ${username}    0.0.0.0/0    md5" | sudo EDITOR="tee -a" /etc/postgresql/9.5/main/postgresql.conf 
  echo -e "${GREEN}Successfully created PostgreSQL user: $username${RESET}"
else
  echo -e "${RED}Skipping Postgres user creation...${RESET}"
fi

# Set up firewall

{
  sudo ufw allow 5432/tcp
  sudo ufw enable &&
  echo -e "${GREEN}Successfully Setup Firewall${RESET}"
  echo -e "${GREEN}!!!Be sure to allow the port on your server (Amazon EC2)!!!${RESET}"
} || {
  echo -e "${RED}Unable to setup firewall${RESET}"
  exit 0
}