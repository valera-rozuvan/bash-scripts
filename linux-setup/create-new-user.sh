#!/bin/bash

USER="desired_username"
PUBLIC_KEY="public_key_string"

useradd -m $USER
usermod --shell /bin/bash $USER
rm -rf /home/$USER/.bashrc
cp /home/valera/.bashrc /home/$USER
chown $USER:$USER /home/$USER/.bashrc
mkdir /home/$USER/.ssh
echo $PUBLIC_KEY > /home/$USER/.ssh/authorized_keys
chown $USER:$USER /home/$USER/.ssh
chown $USER:$USER /home/$USER/.ssh/authorized_keys
cp /home/valera/attach.sh /home/$USER
chown $USER:$USER /home/$USER/attach.sh

echo "Done!"
exit 0
