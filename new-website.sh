#!/bin/bash
# This section adds a website to Apache

# Update repositories

{
  sudo apt-get update &&
  echo -e "${GREEN}Repositories updated${RESET}"
} || {
  echo -e "${RED}Error updating repositories${RESET}"
  exit 0
}

# Install Apache if it isn't already

if [ pgrep -x "apache2" > /dev/null ]; then
 echo "${GREEN}Apache already installed. Skipping installation${RESET}"
else
 echo "${GREEN}Installing Apache...${RESET}"
 sudo apt-get -y install apache2
 sudo ufw allow 'Apache Full'
 sudo update-rc.d apache2 enable
fi

# Create directories

read -e -p "Enter full website domain name [sub.domain.com] " fullDomain

{
  sudo mkdir -p /var/www/$fullDomain/public
  sudo chown -R $USER:$USER /var/www/$fullDomain/public
  sudo chmod -R 755 /var/www &&
  echo -e "${GREEN}Created website directories${RESET}"
} || {
  echo -e "${RED}Error creating website directories${RESET}"
  exit 0
}

# Create virtual host file

read -e -p "Enter your email address " email

{
  sudo cp /etc/apache2/sites-available/000-default.conf /etc/apache2/sites-available/$fullDomain.conf
  sudo sed "s|www.example.com|${fullDomain}|g" /etc/apache2/sites-available/$fullDomain.conf
  sudo sed "s|webmaster@localhost|${email}|g" /etc/apache2/sites-available/$fullDomain.conf
  sudo sed "s|\/var\/www\/html|\/var\/www\/${fullDomain}\/public|g" /etc/apache2/sites-available/$fullDomain.conf &&
  echo -e "${GREEN}Created website virtual host file${RESET}"
} || {
  echo -e "${RED}Error creating website virtual host file${RESET}"
  exit 0
}

# Enable virtual host files

{
  sudo a2ensite $fullDomain
  sudo a2dissite 000-default.conf
  
  sudo service apache2 restart &&
  echo -e "${GREEN}Enabled virtual host file${RESET}"
} || {
  echo -e "${RED}Error enabling virtual host file${RESET}"
  exit 0
}

# Enable HTTPS with LetsEncrypt

read -e -p "Enable HTTPS with LetsEncrypt? [y/n] " -i "y" letsEncrypt

if [[ $letsEncrypt = "Y" || $letsEncrypt = "y" ]]; then
  sudo add-apt-repository -y ppa:certbot/certbot
  sudo apt-get update
  sudo apt-get -y install python-certbot-apache
  sudo certbot --apache -d $fullDomain
  sudo certbot renew --dry-run
else
  echo -e "${RED}Skipping LetsEncrypt...${RESET}"
fi