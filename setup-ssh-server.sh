#!/bin/bash

aptitude install openssh-server

rm -rf /etc/ssh_banner
rm -rf /etc/ssh/sshd_config
rm -rf /etc/ssh/ssh_config

wget https://raw.githubusercontent.com/valera-rozuvan/configs/master/openssh-server/ssh_banner -O /etc/ssh_banner
wget https://raw.githubusercontent.com/valera-rozuvan/configs/master/openssh-server/sshd_config -O /etc/ssh/sshd_config
wget https://raw.githubusercontent.com/valera-rozuvan/configs/master/openssh-server/ssh_config -O /etc/ssh/ssh_config

service ssh restart
service ssh status

mkdir -p /home/valera/.ssh
rm -rf /home/valera/authorized_keys

wget https://github.com/valera-rozuvan.keys -O /home/valera/authorized_keys

echo "Done!"
exit 0
