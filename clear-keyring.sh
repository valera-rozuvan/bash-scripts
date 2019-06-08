#!/bin/bash

gnome-keyring-daemon -r
gpg-connect-agent reloadagent /bye
gpgconf --reload gpg-agent
echo RELOADAGENT | gpg-connect-agent
rm -rf ~/.local/share/keyrings/*.keyring

echo "Done!"

exit 0
