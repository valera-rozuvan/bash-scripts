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

# First, let's see if the file `cgitrepos` needs updating (based on the git repo with that file).
# We run a dedicated script for this.
/home/val/update-cgitrepos-file.sh

# Now we will check the git push log file, and determine whether we need to clear Varnish cache.
OLD_GIT_PUSH_LOG_FILE="/home/val/temp/git_push_log"
LATEST_GIT_PUSH_LOG_FILE="/home/git2/git_push_log"

sudo mkdir -p /home/val/temp/
sudo touch $OLD_GIT_PUSH_LOG_FILE

COMP_RESULT=$(sudo /home/val/compare-2-files.sh $OLD_GIT_PUSH_LOG_FILE $LATEST_GIT_PUSH_LOG_FILE)

if [[ "$COMP_RESULT" == "same" ]]; then
  echo "They are the same."
else
  echo "They are different."
  sudo rm -f $OLD_GIT_PUSH_LOG_FILE
  sudo cp $LATEST_GIT_PUSH_LOG_FILE /home/val/temp/

  sudo systemctl restart lighttpd
  sudo systemctl restart varnish
fi

exit 0
