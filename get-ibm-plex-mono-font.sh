#!/bin/sh

mkdir -p ~/temp
cd ~/temp

wget https://github.com/IBM/type/archive/master.zip
unzip ./master.zip
rm -rf ./master.zip

sudo mkdir -p /usr/share/fonts/truetype/ibm-plex
sudo mkdir -p /usr/share/fonts/opentype/ibm-plex

sudo cp ./plex-master/IBM-Plex-Mono/fonts/complete/ttf/*.ttf /usr/share/fonts/truetype/ibm-plex
sudo cp ./plex-master/IBM-Plex-Mono/fonts/complete/otf/*.otf /usr/share/fonts/opentype/ibm-plex

sudo fc-cache -fv

rm -rf ./plex-master

exit 0
