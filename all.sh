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


echo "
----------------------
  CREATE AND MAINTAIN SWAP
----------------------
"
#checking if swap exists
sudo swapon --show
free -h

#Creating a swap
sudo fallocate -l 2G /swapfile
ls -lh /swapfile
sudo chmod 600 /swapfile
ls -lh /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show

#Making the swap permanent
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab

#Tuning swap setting for SSD based servers
sudo sysctl vm.swappiness=10
sudo sysctl vm.vfs_cache_pressure=50

#Making the swap setttings permanent
sudo cp /etc/sysctl.conf /etc/sysctl.conf.bak
echo 'vm.swappiness=10' | sudo tee -a /etc/sysctl.conf
echo 'vm.vfs_cache_pressure = 50' | sudo tee -a /etc/sysctl.conf

