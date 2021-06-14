#!/bin/bash

aptitude install -y locales
locale-gen "en_US.UTF-8"
echo "LANG=en_US.UTF-8" > /etc/default/locale
echo "LANGUAGE=\"en_US:en\"" >> /etc/default/locale
echo "export LC_ALL=\"en_US.UTF-8\"" >> ~/.bashrc

echo "Done!"
exit 0
