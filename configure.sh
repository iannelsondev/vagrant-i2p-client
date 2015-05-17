#!/bin/bash

## Text settings
bold=$(tput bold)
normal=$(tput sgr0)

#sudo apt-get install mate -y

## Create a random username
I2P_USER=$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)

## Create the user
sudo useradd -m -s /bin/bash $I2P_USER

## Set the password
echo "${I2P_USER}:password" | sudo chpasswd

## Replace the mirror
sudo sed -i 's/archive.ubuntu.com/mirror.umd.edu/g' /etc/apt/sources.list

## Install i2p PPA
sudo add-apt-repository ppa:i2p-maintainers/i2p -y

## Update the system
sudo apt-get update && sudo apt-get upgrade -y

## Install i2p
sudo apt-get install i2p -y

## Install Ubuntu Desktop
sudo apt-get install ubuntu-desktop hexchat -y

## Clean up after desktop
sudo apt-get purge libreoffice* thunderbird unity-webapps-common -y 
sudo apt-get autoremove -y

## Print to the screen
echo "${bold}I2P Login Credentials${normal}"
echo "---------------------"
echo "${bold}Username:${normal} ${I2P_USER}"
echo "${bold}Password:${normal} password"

## Print to file
echo "I2P Login Credentials" > /vagrant/credentials.txt
echo "---------------------" >> /vagrant/credentials.txt
echo "Username: ${I2P_USER}" >> /vagrant/credentials.txt
echo "Password: password" >> /vagrant/credentials.txt

## Start the i2p client router
sudo systemctl enable i2p
sudo systemctl start i2p

## Roll out the Hexchat and Firefox profiles
cd /home/$I2P_USER
sudo tar zxvf /vagrant/i2p-firefox-profile.tar.gz
sudo tar zxvf /vagrant/i2p-hexchat-profile.tar.gz
sudo chown -R $I2P_USER:$I2P_USER /home/$I2P_USER/.mozilla
sudo chown -R $I2P_USER:$I2P_USER /home/$I2P_USER/.config