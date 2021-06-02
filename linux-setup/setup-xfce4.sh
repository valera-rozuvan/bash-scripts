#!/bin/bash

# Install some nice to have X utils.
sudo aptitude update
sudo aptitude upgrade -y
sudo aptitude install -y xclip
sudo apt autoremove -y

# By default xfce4-session tries to start the gpg- or ssh-agent. We disable this behavior.
xfconf-query -c xfce4-session -p /startup/ssh-agent/enabled -n -t bool -s false
xfconf-query -c xfce4-session -p /startup/gpg-agent/enabled -n -t bool -s false

echo "Done!"
exit 0
