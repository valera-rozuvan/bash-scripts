#!/bin/bash

set -o errexit
set -o pipefail

function hndl_SIGHUP() {
  echo "Unfortunately, the script received SIGHUP..."
  exit 1
}
function hndl_SIGINT() {
  echo "Unfortunately, the script received SIGINT..."
  exit 1
}
function hndl_SIGQUIT() {
  echo "Unfortunately, the script received SIGQUIT..."
  exit 1
}
function hndl_SIGABRT() {
  echo "Unfortunately, the script received SIGABRT..."
  exit 1
}
function hndl_SIGTERM() {
  echo "Unfortunately, the script received SIGTERM..."
  exit 1
}

trap hndl_SIGHUP  SIGHUP
trap hndl_SIGINT  SIGINT
trap hndl_SIGQUIT SIGQUIT
trap hndl_SIGABRT SIGABRT
trap hndl_SIGTERM SIGTERM

WD=$(pwd)

chmod u+x $WD/bash/gen_ssh_key.sh
chmod u+x $WD/bash/rnd_str.sh
chmod u+x $WD/linux-setup/setup-debian-10-xfce.sh

mkdir -p ~/bin

rm -rf ~/bin/gen_ssh_key.sh
rm -rf ~/bin/rnd_str.sh
rm -rf ~/bin/setup-debian-10-xfce.sh

ln -s $WD/bash/gen_ssh_key                 ~/bin/gen_ssh_key.sh
ln -s $WD/bash/rnd_str                     ~/bin/rnd_str.sh
ln -s $WD/linux-setup/setup-debian-10-xfce ~/bin/setup-debian-10-xfce.sh

echo -e "\nDone, without errors ;)"
exit 0
