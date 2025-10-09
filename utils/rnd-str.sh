#!/bin/bash

################################################################################
#                                                                              #
# This script is part of a collection of useful Bash scripts.                  #
#                                                                              #
# Script: rnd-str.sh                                                           #
# Description: Generate a random string of length N. Specify N as the first    #
#              argument. Without an argument - length 8 is the default.        #
#                                                                              #
# Author: Valera Rozuvan                                                       #
# GitHub: https://github.com/valera-rozuvan/bash-scripts                       #
# SPDX-License-Identifier: MIT                                                 #
# Last update: 2025-10-14T21:11:59+03:00                                       #
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

SCRIPT_WILL_RUN=0

if [[ "$OSTYPE" == "linux-gnu"* ]] ; then
  SCRIPT_WILL_RUN=1
elif [[ "$OSTYPE" == "darwin"* ]] ; then
  SCRIPT_WILL_RUN=1
elif [[ "$OSTYPE" == "cygwin" ]] ; then
  SCRIPT_WILL_RUN=0
elif [[ "$OSTYPE" == "msys" ]] ; then
  SCRIPT_WILL_RUN=0
elif [[ "$OSTYPE" == "win32" ]] ; then
  SCRIPT_WILL_RUN=0
elif [[ "$OSTYPE" == "freebsd"* ]] ; then
  SCRIPT_WILL_RUN=0
else
  SCRIPT_WILL_RUN=0
fi

if [[ "$SCRIPT_WILL_RUN" == "0" ]] ; then
  echo "ERROR. OS type '${OSTYPE}' not supported! Script will exit."
  exit 1
fi

LENGTH=${1:-8}
SILENT=${2:-q}

if ! [[ "$LENGTH" =~ ^[0-9]+$ ]] ; then
  echo "ERROR. Please provide a positive integer as 1st argument to this script."
  exit 1
fi

if [[ $LENGTH -eq 0 ]] ; then
  echo "ERROR. Length can't equal 0."
  exit 1
fi

if [[ "$OSTYPE" == "linux-gnu"* ]] ; then
  RND=$(tr -dc 'A-Za-z0-9' < /dev/urandom | head -c "${LENGTH}" 2> /dev/null || true)
elif [[ "$OSTYPE" == "darwin"* ]] ; then
  RND=$(env LC_ALL=C tr -dc 'a-zA-Z0-9' < /dev/urandom | fold -w "${LENGTH}" | head -n 1)
fi

if [[ "$SILENT" = "v" ]] ; then
  echo -e "Verbose mode.\n"

  echo "OSTYPE = ${OSTYPE}"
  echo "LENGTH = ${LENGTH}"
  echo "RND = ${RND}"
else
  echo "${RND}"
fi

exit 0

# ----- end-of: Main logic -----------------------------------------------------
