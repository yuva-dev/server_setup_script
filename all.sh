#!/usr/bin/env bash

echo "
----------------------
  NODE & NPM
----------------------
"

curl -sL https://deb.nodesource.com/setup_12.x | sudo -E bash -
# install nodejs and npm
sudo apt-get install -y nodejs

echo "
----------------------
  MONGODB
----------------------
"

# import key
wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
# update sources.list
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list
# reload local package database
sudo apt-get update
# install the latest version of mongodb
sudo apt-get install -y mongodb-org
# start mongodb
sudo systemctl start mongod
# set mongodb to start automatically on system startup
sudo systemctl enable mongod

echo "
----------------------
  PM2
----------------------
"

# install pm2 with npm
sudo npm install -g pm2
# set pm2 to start automatically on system startup
sudo pm2 startup systemd

echo "
----------------------
  NGINX
----------------------
"

# install nginx
sudo apt-get install -y nginx


echo "
----------------------
  UFW (FIREWALL)
----------------------
"

# allow ssh connections through firewall
sudo ufw allow OpenSSH
# allow http & https through firewall
sudo ufw allow 'Nginx Full'
# enable firewall
sudo ufw --force enable
