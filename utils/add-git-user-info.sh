#!/bin/bash

################################################################################
#                                                                              #
# This script is part of a collection of useful Bash scripts.                  #
#                                                                              #
# Script: add-git-user-info.sh                                                 #
# Description: Adds some user configuration to the main git config file in a   #
#              repository. Name, e-mail, GPG key. Also enables GPG signing of  #
#              a commit.                                                       #
#                                                                              #
# Author: Valera Rozuvan                                                       #
# GitHub: https://github.com/valera-rozuvan/bash-scripts                       #
# SPDX-License-Identifier: MIT                                                 #
# Last update: 2025-10-10T21:10:27+03:00                                       #
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

GIT_FOLDER="./.git"
if [[ -d $GIT_FOLDER ]]; then
  echo "Git folder '$GIT_FOLDER'. It is a directory. Good :-)"
elif [[ -f $GIT_FOLDER ]]; then
  echo "Git folder '$GIT_FOLDER'. It is a file, but should be a directory."
  exit 1
else
  echo "Git folder '$GIT_FOLDER'. No file or directory with such a name."
  exit 1
fi

GIT_CONFIG="${GIT_FOLDER}/config"
if [[ -d $GIT_CONFIG ]]; then
  echo "Git config '$GIT_CONFIG'. It is a directory, but should be a file."
  exit 1
elif [[ -f $GIT_CONFIG ]]; then
  echo "Git config '$GIT_CONFIG'. It is a file. Good :-)"
else
  echo "Git config '$GIT_CONFIG'. No file or directory with such a name."
  exit 1
fi

GREP_STATUS=""
grep -F "[user]" "${GIT_CONFIG}" 1> /dev/null 2> /dev/null \
  && GREP_STATUS="found" \
  || GREP_STATUS="not-found"

if [ "$GREP_STATUS" == "found" ]; then
  echo "User info found in Git config. Not doing anything."
  exit 0
elif [ "$GREP_STATUS" == "not-found" ]; then
  echo "User info NOT found in Git config."
else
  echo "Something unexpected happened! Exiting."
  exit 1
fi

USER_GPG_KEY="DEF3CC36F64590C7"
USER_FULL_NAME="Valera Rozuvan"
USER_EMAIL="valera@rozuvan.net"

echo -e "Will add the following to the Git config:\n"

gen_user_config() {
  echo "[user]"
  echo "	name = ${USER_FULL_NAME}"
  echo "	email = ${USER_EMAIL}"
  echo "	signingkey = ${USER_GPG_KEY}"
  echo "[gpg]"
  echo "	program = gpg"
  echo "[commit]"
  echo "	gpgsign = true"
  echo ""
}

# print to stdout what we are about to append to $GIT_CONFIG file
gen_user_config

# now append the same to the config file
gen_user_config >> "${GIT_CONFIG}"

exit 0

# ----- end-of: Main logic -----------------------------------------------------
