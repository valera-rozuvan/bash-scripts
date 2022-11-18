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

CGITREPOS_REPO="/home/git2/cgitrepos.git"
CGITREPOS_TEMP_REPO="/home/val/temp/cgitrepos"
CGITREPOS_FILE="/home/git2/cgitrepos"
CGITREPOS_TEMP_FILE="${CGITREPOS_TEMP_REPO}/cgitrepos"

# Let's make sure that all necessary parent folders exist. Note the `-p` flag.
sudo mkdir -p $CGITREPOS_TEMP_REPO

if [[ -f "${CGITREPOS_TEMP_FILE}" ]]; then
  echo "${CGITREPOS_TEMP_FILE} exists. Now we will check if there are changes in the upstream repo."

  cd $CGITREPOS_TEMP_REPO
  sudo git fetch
  HEADHASH=$(sudo git rev-parse HEAD)
  UPSTREAMHASH=$(sudo git rev-parse 'master@{upstream}')

  if [[ "$HEADHASH" != "$UPSTREAMHASH" ]]; then
    echo "NOT up to date with the upstream. We will get latest changes, and restart cgit & friends."
  else
    echo "We are up to date with the upstream. No action needs to be taken."

    echo "Done!"
    exit 0
  fi
else
  echo "${CGITREPOS_TEMP_FILE} DOES NOT exist. Will clone repo from scratch."

  sudo rm -rf $CGITREPOS_TEMP_REPO
  sudo git clone $CGITREPOS_REPO $CGITREPOS_TEMP_REPO
fi

cd $CGITREPOS_TEMP_REPO
sudo git pull origin master

if [[ -f "${CGITREPOS_TEMP_FILE}" ]]; then
  echo "Updating 'cgitrepos' file to the latest version from git repo."

  sudo rm -rf $CGITREPOS_FILE
  sudo cp $CGITREPOS_TEMP_FILE /home/git2/

  sudo chown git2:git2 $CGITREPOS_FILE
  sudo chgrp git2 $CGITREPOS_FILE
  sudo chmod a+r $CGITREPOS_FILE
  sudo chmod a-w $CGITREPOS_FILE
else
  echo "The upstream repo is missing the required file. Will not do anything."
fi

echo "Done!"
exit 0
