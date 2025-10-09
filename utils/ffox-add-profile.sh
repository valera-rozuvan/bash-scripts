#!/bin/bash

################################################################################
#                                                                              #
# This script is part of a collection of useful Bash scripts.                  #
#                                                                              #
# Script: ffox-add-profile.sh                                                  #
# Description: Sets up a new folder to be used as a Firefox profile. Part of   #
#              the collection of scripts to work with Firefox profiles:        #
#                - ffox-add-profile.sh                                         #
#                - ffox-private.sh                                             #
#                - ffox-profile.sh                                             #
#                                                                              #
# Author: Valera Rozuvan                                                       #
# GitHub: https://github.com/valera-rozuvan/bash-scripts                       #
# SPDX-License-Identifier: MIT                                                 #
# Last update: 2025-10-11T17:59:07+03:00                                       #
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

# Check if a parameter is provided.
if [ -z "$1" ]; then
  echo "Usage: $0 <profile_name>"
  exit 1
fi

PROFILE_NAME="${1}"
HOME_DIRECTORY=$(eval echo "~${USER}")
MOZL_PROFILE_FOLDER="${HOME_DIRECTORY}/custom-mozilla-profiles"
DIRECTORY_TO_CHECK="${MOZL_PROFILE_FOLDER}/${PROFILE_NAME}"

echo "Profile name: '${PROFILE_NAME}'"
# Check if profile name contains valid characters.
if [[ "$PROFILE_NAME" =~ ^[a-zA-Z0-9-]+$ ]]; then
  echo "   |--> Name is valid."
else
  echo "   |--> Contains invalid characters!"
  echo "   |--> Only uppercase letters," \
       "lowercase letters, digits, or hyphens are allowed!"
  exit 1
fi

echo "Profile directory: '$DIRECTORY_TO_CHECK'"
# Check if the profile directory path exists and is a directory.
if [ -d "$DIRECTORY_TO_CHECK" ]; then
  echo "   |--> Directory exists. No action taken."
else
  mkdir -p "$DIRECTORY_TO_CHECK"
  echo "   |--> Directory created."
fi

exit 0

# ----- end-of: Main logic -----------------------------------------------------
