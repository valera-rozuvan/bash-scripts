#!/bin/bash

set -o errexit
set -o pipefail

function handle_exit() {
  echo "Unfortunately, the script did not finish..."
  exit 1
}

trap handle_exit SIGHUP SIGINT SIGQUIT SIGABRT SIGTERM

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
sudo aptitude install -y wget curl mc screen emacs git bzip2 pass xclip p7zip p7zip-full gawk diceware

# By default xfce4-session tries to start the gpg- or ssh-agent. We disable this behavior.
xfconf-query -c xfce4-session -p /startup/ssh-agent/enabled -n -t bool -s false
xfconf-query -c xfce4-session -p /startup/gpg-agent/enabled -n -t bool -s false

rm -rf ~/.dotfiles
git clone https://github.com/valera-rozuvan/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
./install.sh
cd ~/
. ~/.bashrc

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

wget -O $TEMP_FOLDER/firefox.tar.bz2 "https://download.mozilla.org/?product=firefox-latest-ssl&os=linux64&lang=en-US"
sudo rm -rf /opt/firefox
sudo mkdir -p /opt
sudo tar -xvjf $TEMP_FOLDER/firefox.tar.bz2 -C /opt

sudo rm -rf /usr/bin/firefox
sudo ln -s /opt/firefox/firefox /usr/bin/firefox

sudo update-alternatives --install /usr/bin/x-www-browser x-www-browser /opt/firefox/firefox 500
sudo update-alternatives --set x-www-browser /opt/firefox/firefox

sudo update-alternatives --install /usr/bin/www-browser www-browser /opt/firefox/firefox 500
sudo update-alternatives --set www-browser /opt/firefox/firefox

sudo update-alternatives --install /usr/bin/gnome-www-browser gnome-www-browser /opt/firefox/firefox 500
sudo update-alternatives --set gnome-www-browser /opt/firefox/firefox

sudo aptitude install -y autoconf automake make gcc g++ libxft-dev libxft2 libxt-dev fonts-dejavu fonts-dejavu-core fonts-dejavu-extra

wget -O $TEMP_FOLDER/rxvt-unicode-9.26.tar.bz2 http://dist.schmorp.de/rxvt-unicode/rxvt-unicode-9.26.tar.bz2
tar -xvjf $TEMP_FOLDER/rxvt-unicode-9.26.tar.bz2 -C $TEMP_FOLDER
cd $TEMP_FOLDER/rxvt-unicode-9.26
./configure CC=gcc --disable-perl
make -j 2
sudo make install
sudo update-alternatives --install /usr/bin/x-terminal-emulator x-terminal-emulator /usr/local/bin/urxvt 500
sudo update-alternatives --set x-terminal-emulator /usr/local/bin/urxvt
cd ~/

rm -rf $TEMP_FOLDER

BIN_FOLDER=~/bin
rm -rf $BIN_FOLDER
mkdir -p $BIN_FOLDER

wget -O $BIN_FOLDER/gen_ssh_key https://raw.githubusercontent.com/valera-rozuvan/shell-script-collection/master/bash/gen_ssh_key.sh
chmod u+x $BIN_FOLDER/gen_ssh_key

wget -O $BIN_FOLDER/rnd_str https://raw.githubusercontent.com/valera-rozuvan/shell-script-collection/master/bash/rnd_str.sh
chmod u+x $BIN_FOLDER/rnd_str

sudo aptitude install -y python3-pip
sudo -H pip3 install glances

sudo aptitude install pinentry-curses
sudo update-alternatives --install /usr/bin/pinentry pinentry /usr/bin/pinentry-curses 500
sudo update-alternatives --set pinentry /usr/bin/pinentry-curses

# Clean up any unnecessary apt packages that did not uninstall automatically in the previous steps.
sudo apt autoremove -y

echo -e "\nDone!"
exit 0
