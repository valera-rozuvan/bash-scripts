#!/bin/bash

################################################################################
#                                                                              #
# This script is part of a collection of useful Bash scripts.                  #
#                                                                              #
# Script: gen-ssh-key.sh                                                       #
# Description: Generates a SSH key (for now only `ed25519` type), saves it     #
#              to `~/.ssh/${RANDOM_ID}/ed25519`, and also prints all info      #
#              about the key to `stdout`.                                      #
#                                                                              #
# Author: Valera Rozuvan                                                       #
# GitHub: https://github.com/valera-rozuvan/bash-scripts                       #
# SPDX-License-Identifier: MIT                                                 #
# Last update: 2025-10-14T14:51:00+03:00                                       #
# Bash: GNU bash, version 5.2.37(1)-release (x86_64-pc-linux-gnu)              #
#                                                                              #
################################################################################



# ----- SETUP Bash flags -------------------------------------------------------

################################################################################
#                                                                              #
# Adding the `-x` option when executing `bash`, or using `set -x` inside a     #
# Bash script, makes Bash print commands and their arguments as they are       #
# executed. Useful for debugging.                                              #
#                                                                              #
# You can use the following line, to help find out why the script is exiting   #
# with an error:                                                               #
#                                                                              #
#   set -Eeuxo pipefail                                                        #
#                                                                              #
# By default, we turn this debugging feature off.                              #
#                                                                              #
################################################################################

set -Eeuo pipefail

# ----- end-of: SETUP Bash flags -----------------------------------------------



# ----- SETUP traps ------------------------------------------------------------

################################################################################
#                                                                              #
# Setup trap handlers for various signals:                                     #
#                                                                              #
#   - SIGHUP                                                                   #
#   - SIGINT                                                                   #
#   - SIGQUIT                                                                  #
#   - SIGABRT                                                                  #
#   - SIGTERM                                                                  #
#   - EXIT                                                                     #
#   - ERR                                                                      #
#                                                                              #
################################################################################

# Don't warn about unreachable commands in this function.
# shellcheck disable=SC2317
function hndl_SIGHUP() {
  echo "Unfortunately, the script received SIGHUP..."
  exit 1
}

# Don't warn about unreachable commands in this function.
# shellcheck disable=SC2317
function hndl_SIGINT() {
  echo "Unfortunately, the script received SIGINT..."
  exit 1
}

# Don't warn about unreachable commands in this function.
# shellcheck disable=SC2317
function hndl_SIGQUIT() {
  echo "Unfortunately, the script received SIGQUIT..."
  exit 1
}

# Don't warn about unreachable commands in this function.
# shellcheck disable=SC2317
function hndl_SIGABRT() {
  echo "Unfortunately, the script received SIGABRT..."
  exit 1
}

# Don't warn about unreachable commands in this function.
# shellcheck disable=SC2317
function hndl_SIGTERM() {
  echo "Unfortunately, the script received SIGTERM..."
  exit 1
}

# Don't warn about unreachable commands in this function.
# shellcheck disable=SC2317
function hndl_EXIT() {
  # echo "The script hit an EXIT..."
  exit 0
}

# Don't warn about unreachable commands in this function.
# shellcheck disable=SC2317
function hndl_ERR() {
  echo "The script hit an ERR..."
  exit 1
}

trap hndl_SIGHUP  SIGHUP
trap hndl_SIGINT  SIGINT
trap hndl_SIGQUIT SIGQUIT
trap hndl_SIGABRT SIGABRT
trap hndl_SIGTERM SIGTERM
trap hndl_EXIT    EXIT
trap hndl_ERR     ERR

# ----- end-of: SETUP traps ----------------------------------------------------



# ----- Main logic -------------------------------------------------------------

KEY_TYPE="ed25519"

KEY_HASH=$(rnd-str.sh 32)
KEY_PSWD=$(rnd-str.sh 64)

mkdir -p "${HOME}/.ssh/${KEY_HASH}"
ssh-keygen \
  -C "${KEY_HASH}" \
  -f "${HOME}/.ssh/${KEY_HASH}/ed25519" \
  -P "${KEY_PSWD}" \
  -t "${KEY_TYPE}" > /dev/null 2>&1

echo "Key type: ${KEY_TYPE}"
echo "Key hash: ${KEY_HASH}"
echo -e "Key pswd: ${KEY_PSWD}\n"

PUB_FILE="${HOME}/.ssh/${KEY_HASH}/${KEY_TYPE}.pub"
echo "Public key file '${PUB_FILE}':"
cat "${PUB_FILE}"

PRIV_FILE="${HOME}/.ssh/${KEY_HASH}/${KEY_TYPE}"
echo -e "\nPrivate key file '${PRIV_FILE}':"
cat "${PRIV_FILE}"

exit 0

# ----- end-of: Main logic -----------------------------------------------------
