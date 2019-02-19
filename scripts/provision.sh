#!/bin/bash

# Make sure apt repository db is up to date
sudo apt-get update

# Install tools
echo "Installing tools...."
which wget curl telnet unzip &>/dev/null || {
  sudo apt-get install -y wget curl telnet unzip
}

# Check if nginx is installed
# Install nginx if not installed
echo "Installing nginx...."
which nginx &>/dev/null || {
  sudo apt-get install -y nginx
}

# Configure nginx
echo "Configuring nginx...."
# Stop nginx service
sudo systemctl stop nginx.service
# Remove default conf of nginx
[ -f /etc/nginx/sites-available/default ] && {
 sudo rm -fr /etc/nginx/sites-available/default
}
# Copy our nginx conf
sudo cp ~/nginx.conf /etc/nginx/sites-available/default
# Start nginx service
sudo systemctl start nginx.service

# Install java-jdk required for jenkins to run
echo "Installing Java JDK...."
which java &>/dev/null || {
  sudo apt-get install -y default-jdk
}

# Install jenkins  
echo "Installing Jenkins...."
which jenkins &>/dev/null || {
  wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
  sudo sh -c 'echo deb http://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
  sudo apt-get update
  sudo apt-get install -y jenkins
}

sudo systemctl enable jenkins.service
sudo systemctl start jenkins.service

# Install EFF's Certbot tool
echo "Installing Certbot...."
sudo apt-get install software-properties-common -y
sudo add-apt-repository universe
sudo add-apt-repository ppa:certbot/certbot -y
sudo apt-get update
sudo apt-get install python-certbot-nginx -y

# Deploying Let's Encrypt certificate
#echo "Generating SSL Certificate for nginx with Certbot...."
#EMAIL=atanas.v4@gmail.com
#DOMAIN_NAME=jenkins.ntry.site
#sudo certbot --nginx --non-interactive --agree-tos -m ${EMAIL} -d ${DOMAIN_NAME} --redirect

# Create cron job to check and renew certificate on expiration
crontab <<EOF
0 12 * * * /usr/bin/certbot renew --quiet
EOF