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
echo "[setup-02] step 1"

sudo apt-get update
sudo apt-get upgrade -y

# ----------------------------------------------------------------------------------------------
echo "[setup-02] step 2"

SWAP_BASE_DIR=$(df -h | grep -i "${SWAP_VOLUME_ID}" | awk '{ print $6 }')
SWAP_FILE=$SWAP_BASE_DIR/swap.1

sudo /bin/dd if=/dev/zero of="${SWAP_FILE}" bs=1M count=8192
sudo /sbin/mkswap "${SWAP_FILE}"
sudo chmod 600 "${SWAP_FILE}"
sudo /sbin/swapon "${SWAP_FILE}"

echo "${SWAP_FILE}   swap    swap    defaults        0   0" | sudo tee -a /etc/fstab > /dev/null

# ----------------------------------------------------------------------------------------------
echo "[setup-02] step 3"

screen -dmS reboot "${ADMIN_USER_HOME_DIR}/reboot-in-5s.sh"

echo -e "\nDone, without errors ;)"
exit 0
