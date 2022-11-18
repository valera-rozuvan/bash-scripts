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

# ----------------------------------------------------------------------------------------------
echo "[setup-03] step 1"

sudo apt-get install -y aptitude
sudo aptitude install -y --without-recommends \
  ufw \
  fail2ban \
  cgit \
  git \
  nginx \
  fcgiwrap \
  certbot \
  python3 \
  python3-pip \
  python3-setuptools \
  python3-dev \
  python3-pygments \
  python3-markdown \
  python3-certbot-nginx \
  gcc \
  pv \
  rsync

# ----------------------------------------------------------------------------------------------
echo "[setup-03] step 2"

sudo systemctl stop fail2ban
sudo systemctl disable fail2ban

sudo systemctl stop nginx
sudo systemctl disable nginx

# ----------------------------------------------------------------------------------------------
echo "[setup-03] step 3"

sudo aptitude install -y --without-recommends lighttpd lighttpd-doc lighttpd-mod-deflate

sudo systemctl stop lighttpd
sudo systemctl disable lighttpd

# ----------------------------------------------------------------------------------------------
echo "[setup-03] step 4"

sudo aptitude install -y varnish

sudo systemctl stop varnish
sudo systemctl disable varnish

# ----------------------------------------------------------------------------------------------
echo "[setup-03] step 5"

sudo -H pip3 install glances

# ----------------------------------------------------------------------------------------------
echo "[setup-03] step 6"

sudo ufw allow 22
sudo ufw allow 80
sudo ufw allow 443

echo "y" | sudo ufw enable

# ----------------------------------------------------------------------------------------------
echo "[setup-03] step 7"

screen -dmS reboot "${ADMIN_USER_HOME_DIR}/reboot-in-5s.sh"

echo -e "\nDone, without errors ;)"
exit 0
