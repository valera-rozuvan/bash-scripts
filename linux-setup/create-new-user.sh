#!/bin/bash

USER=""
PUBLIC_KEY=""
USER_PSWD=""

useradd -m $USER
usermod --shell /bin/bash $USER
rm -rf /home/$USER/.bashrc

# See example of `.bashrc.user` file here:
#   https://raw.githubusercontent.com/valera-rozuvan/shell-script-collection/master/linux-setup/.bashrc.user
cp /root/.bashrc.user /home/$USER/.bashrc

chown $USER:$USER /home/$USER/.bashrc
mkdir /home/$USER/.ssh
echo $PUBLIC_KEY > /home/$USER/.ssh/authorized_keys
chown $USER:$USER /home/$USER/.ssh
chown $USER:$USER /home/$USER/.ssh/authorized_keys

echo "${USER}:${USER_PSWD}" | chpasswd

echo "Done!"
exit 0
