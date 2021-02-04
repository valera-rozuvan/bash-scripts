#!/bin/bash

USER="desired_username"
PUBLIC_KEY="public_key_string"

useradd -m $USER
usermod --shell /bin/bash $USER
rm -rf /home/$USER/.bashrc

# See example of `.bashrc.user` file here:
#   https://github.com/valera-rozuvan/shell-script-collection/blob/master/linux-setup/.bashrc.user
cp /root/.bashrc.user /home/$USER

chown $USER:$USER /home/$USER/.bashrc
mkdir /home/$USER/.ssh
echo $PUBLIC_KEY > /home/$USER/.ssh/authorized_keys
chown $USER:$USER /home/$USER/.ssh
chown $USER:$USER /home/$USER/.ssh/authorized_keys

echo "Done!"
exit 0
