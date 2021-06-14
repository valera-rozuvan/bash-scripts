#!/bin/bash

set -o errexit
set -o pipefail

function hndl_SIGHUP() {
  echo "Unfortunately, the script received SIGHUP..."
  exit 1
}
function hndl_SIGINT() {
  echo "Unfortunately, the script received SIGINT..."
  exit 1
}
function hndl_SIGQUIT() {
  echo "Unfortunately, the script received SIGQUIT..."
  exit 1
}
function hndl_SIGABRT() {
  echo "Unfortunately, the script received SIGABRT..."
  exit 1
}
function hndl_SIGTERM() {
  echo "Unfortunately, the script received SIGTERM..."
  exit 1
}

trap hndl_SIGHUP  SIGHUP
trap hndl_SIGINT  SIGINT
trap hndl_SIGQUIT SIGQUIT
trap hndl_SIGABRT SIGABRT
trap hndl_SIGTERM SIGTERM

# This script assumes that the user can run commands via sudo without providing a password.
# If sudo requires a password, run some command via sudo before running this script.
# Remember, if password is provided, sudo will cache (and re-use) the password for some time.
#
# Latest version of this script can be found at:
#
#   https://raw.githubusercontent.com/valera-rozuvan/shell-script-collection/master/linux-setup/setup-debian-10-xfce.sh

sudo apt-get remove -y apt-listchanges

# Note, below steps for locale setup are mostly Debian specific.
sudo apt-get install -y locales
UTF8_EN_US_LOCALE=$(cat /usr/share/i18n/SUPPORTED | grep -i "utf-8" | grep -i "en" | grep -i "us")
echo $UTF8_EN_US_LOCALE | sudo tee /etc/locale.gen > /dev/null
sudo locale-gen

APT_SRC_FILE="/etc/apt/sources.list"
echo "" > sudo tee $APT_SRC_FILE > /dev/null
echo "deb http://mirror.netcologne.de/debian/ buster main contrib non-free"                    >> sudo tee -a $APT_SRC_FILE > /dev/null
echo "deb-src http://mirror.netcologne.de/debian/ buster main contrib non-free"                >> sudo tee -a $APT_SRC_FILE > /dev/null
echo "deb http://security.debian.org/debian-security buster/updates main contrib non-free"     >> sudo tee -a $APT_SRC_FILE > /dev/null
echo "deb-src http://security.debian.org/debian-security buster/updates main contrib non-free" >> sudo tee -a $APT_SRC_FILE > /dev/null
echo "deb http://mirror.netcologne.de/debian/ buster-updates main contrib non-free"            >> sudo tee -a $APT_SRC_FILE > /dev/null
echo "deb-src http://mirror.netcologne.de/debian/ buster-updates main contrib non-free"        >> sudo tee -a $APT_SRC_FILE > /dev/null

sudo apt-get update
sudo apt-get upgrade -y
sudo apt-get install -y aptitude
sudo aptitude update
sudo aptitude upgrade -y
sudo aptitude install -y wget curl mc screen emacs git bzip2 pass p7zip p7zip-full gawk diceware

rm -rf ~/.dotfiles
git clone https://github.com/valera-rozuvan/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
cd ~/
. ~/.bashrc

rm -rf ~/.scripts
git clone https://github.com/valera-rozuvan/shell-script-collection.git ~/.scripts
cd ~/.scripts
./install.sh
cd ~/

TEMP_FOLDER=~/temp_328473289474

rm -rf $TEMP_FOLDER
mkdir -p $TEMP_FOLDER

wget -O $TEMP_FOLDER/ssh_banner https://raw.githubusercontent.com/valera-rozuvan/configs/master/openssh-server/ssh_banner
wget -O $TEMP_FOLDER/ssh_config https://raw.githubusercontent.com/valera-rozuvan/configs/master/openssh-server/ssh_config
wget -O $TEMP_FOLDER/sshd_config https://raw.githubusercontent.com/valera-rozuvan/configs/master/openssh-server/sshd_config

sudo aptitude install -y openssh-server
sudo rm -rf /etc/ssh/ssh_config
sudo rm -rf /etc/ssh/sshd_config
sudo cp $TEMP_FOLDER/ssh_banner /etc/
sudo cp $TEMP_FOLDER/ssh_config /etc/ssh/
sudo cp $TEMP_FOLDER/sshd_config /etc/ssh/
sudo systemctl restart sshd

rm -rf ~/.ssh
mkdir ~/.ssh

sudo aptitude install -y ufw
sudo ufw deny 22
sudo ufw allow 7001
sudo ufw enable

sudo apt-get -y remove '^libreoffice-help-.*'
sudo aptitude install -f -y
sudo apt-get -y remove '^firefox-.*'
sudo aptitude install -f -y

rm -rf ~/.cache/mozilla
rm -rf ~/.mozilla

sudo aptitude install -y python3-pip
sudo -H pip3 install glances

sudo aptitude install pinentry-curses
sudo update-alternatives --install /usr/bin/pinentry pinentry /usr/bin/pinentry-curses 500
sudo update-alternatives --set pinentry /usr/bin/pinentry-curses

# Clean up tempo folder.
rm -rf $TEMP_FOLDER

# Clean up any unnecessary apt packages that did not uninstall automatically in the previous steps.
sudo apt autoremove -y

echo -e "\nDone, without errors ;)"
exit 0
