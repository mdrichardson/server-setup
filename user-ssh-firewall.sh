#!/bin/bash
# This section creates a new user, gives them root privileges and ssh access, then disables password authentication and enables ssh on the firewall

# Color variables
RED=`tput setaf 1`
GREEN=`tput setaf 2`
RESET=`tput sgr0`

# Add User

read -e -p "Enter new username: " Username
{
  sudo adduser $Username sudo &&
  echo -e "${GREEN}Added user: $Username${RESET}"
  sudo passwd -d "$Username"
  echo "${Username} ALL=(ALL) NOPASSWD:ALL" | sudo EDITOR="tee -a" visudo
} || {
  echo -e "${RED}Error setting $Username${RESET}"
  exit 0
}

# Assign root priveleges to user

{
  sudo usermod -aG sudo $Username &&
  echo -e "${GREEN}Added root priveleges for $Username${RESET}"
} || {
  echo -e "${RED}Error giving user root priveleges${RESET}"
  exit 0
}

# Give user SSH access

{
  sudo -u $Username mkdir -p /home/$Username/.ssh/
  sudo chmod 700 /home/$Username/.ssh
  sudo cp /home/ubuntu/.ssh/authorized_keys /home/$Username/.ssh/authorized_keys
  sudo chmod 600 /home/$Username/.ssh/authorized_keys
  sudo chown $Username:$Username /home/$Username/.ssh -R
  sudo sed 's|#AuthorizedKeysFile|AuthorizedKeysFile|g' /etc/ssh/sshd_config
  echo -e "${GREEN}Successfully copied SSH Key${RESET}"
} || {
  echo -e "${RED}Error copying SSH Key to file${RESET}"
  exit 0
}

# Disable Password Authentication

{
  sudo sed 's|#PassowrdAuthenitcation no|PasswordAuthentication no|g' /etc/ssh/sshd_config &&
  sudo systemctl reload sshd &&
  echo -e "${GREEN}Successfully Disabled Password Authentication${RESET}"
} || {
  echo -e "${RED}Error disabling passowrd authentication${RESET}"
  exit 0
}

# Set up firewall

{
  sudo ufw allow OpenSSH
  sudo ufw enable &&
  echo -e "${GREEN}Successfully Setup Firewall${RESET}"
} || {
  echo -e "${RED}Unable to setup firewall${RESET}"
  exit 0
}