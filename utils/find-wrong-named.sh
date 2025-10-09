#!/bin/bash

################################################################################
#                                                                              #
# This script is part of a collection of useful Bash scripts.                  #
#                                                                              #
# Script: find-wrong-named.sh                                                  #
# Description: Find all files and folders whose name contains an invalid       #
#              character. We only want to have the following characters in     #
#              the name:                                                       #
#                a-zA-Z0-9-_.                                                  #
#                                                                              #
#              Yes, I know that some languages (Perl, Python, etc.) have a     #
#              more elegant solution for this problem. I was aiming for Bash   #
#              only approach.                                                  #
#                                                                              #
# Author: Valera Rozuvan                                                       #
# GitHub: https://github.com/valera-rozuvan/bash-scripts                       #
# SPDX-License-Identifier: MIT                                                 #
# Last update: 2025-10-14T14:27:49+03:00                                       #
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

find "$PWD/" -name "* *"
find "$PWD/" -name "*)*"
find "$PWD/" -name "*(*"
find "$PWD/" -name "*[*"
find "$PWD/" -name "*]*"
find "$PWD/" -name "*}*"
find "$PWD/" -name "*{*"
find "$PWD/" -name "*:*"
find "$PWD/" -name "*;*"
find "$PWD/" -name "*,*"
find "$PWD/" -name "*\$*"
find "$PWD/" -name "*#*"
find "$PWD/" -name "*\\\*"
find "$PWD/" -name "*~*"
find "$PWD/" -name "*\`*"
find "$PWD/" -name "*\'*"
find "$PWD/" -name "*\"*"
find "$PWD/" -name "*\!*"
find "$PWD/" -name "*|*"
find "$PWD/" -name "*@*"
find "$PWD/" -name "*%*"
find "$PWD/" -name "*^*"
find "$PWD/" -name "*&*"
find "$PWD/" -name "*\**"
find "$PWD/" -name "*=*"
find "$PWD/" -name "*+*"
find "$PWD/" -name "*>*"
find "$PWD/" -name "*<*"
find "$PWD/" -name "*\?*"

exit 0

# ----- end-of: Main logic -----------------------------------------------------
