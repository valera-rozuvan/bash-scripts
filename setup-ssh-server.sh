#!/bin/bash

sudo aptitude install openssh-server

sudo rm -rf /etc/ssh_banner
sudo rm -rf /etc/ssh/sshd_config
sudo rm -rf /etc/ssh/ssh_config

wget https://raw.githubusercontent.com/valera-rozuvan/configs/master/openssh-server/ssh_banner
wget https://raw.githubusercontent.com/valera-rozuvan/configs/master/openssh-server/sshd_config
wget https://raw.githubusercontent.com/valera-rozuvan/configs/master/openssh-server/ssh_config

sudo mv ssh_banner /etc/ssh_banner
sudo mv sshd_config /etc/ssh/sshd_config
sudo mv ssh_config /etc/ssh/ssh_config

sudo service ssh restart
sudo service ssh status

rm -rf /home/valera/.ssh
mkdir -p /home/valera/.ssh

wget https://github.com/valera-rozuvan.keys -O /home/valera/.ssh/authorized_keys

echo "Done!"
exit 0
