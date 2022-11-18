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
echo "[setup-05] step 1"

touch "${ADMIN_USER_HOME_DIR}"/crontab_log

"${ADMIN_USER_HOME_DIR}"/clear-varnish-cache.sh >> "${ADMIN_USER_HOME_DIR}"/crontab_log 2>&1

# We have `|| true` in the below line, since we don't want the script to silently fail if there are no cronjobs.
# If there are no cronjobs, `crontab -l` will return an error (exit code 1).
# Therefore we use `|| true` below.
(crontab -l 2>/dev/null || true; echo "*/2 * * * * ${ADMIN_USER_HOME_DIR}/clear-varnish-cache.sh >> ${ADMIN_USER_HOME_DIR}/crontab_log 2>&1") | crontab -

# ----------------------------------------------------------------------------------------------

echo -e "\nDone, without errors ;)"
exit 0
