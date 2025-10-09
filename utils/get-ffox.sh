#!/bin/bash

################################################################################
#                                                                              #
# This script is part of a collection of useful Bash scripts.                  #
#                                                                              #
# Script: get-ffox.sh                                                          #
# Description: Downloads Firefox release for `linux-x86_64` architecture,      #
#              checks the sha256sum of the downloaded file, and extracts to    #
#              `~/bin` folder.                                                 #
#                                                                              #
# Author: Valera Rozuvan                                                       #
# GitHub: https://github.com/valera-rozuvan/bash-scripts                       #
# SPDX-License-Identifier: MIT                                                 #
# Last update: 2025-10-14T22:07:38+03:00                                       #
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

mkdir -p "${HOME}/Downloads"
cd "${HOME}/Downloads"

rm -rf ./SHA256SUMS
rm -rf ./firefox-143.0.4.tar.xz.sha256sum.txt
rm -rf ./firefox-143.0.4.tar.xz
rm -rf ./linux-x86_64/en-US/
rm -rf ./firefox

BASE_URL="https://ftp.mozilla.org/pub/firefox/releases/143.0.4"

curl \
  --proto '=https' \
  --tlsv1.2 \
  -sSf \
  "${BASE_URL}/SHA256SUMS" \
  -o SHA256SUMS

curl \
  --proto '=https' \
  --tlsv1.2 \
  -sSf \
  "${BASE_URL}/linux-x86_64/en-US/firefox-143.0.4.tar.xz" \
  -o firefox-143.0.4.tar.xz

mkdir -p ./linux-x86_64/en-US/
mv firefox-143.0.4.tar.xz ./linux-x86_64/en-US/

grep -i "143.0.4" SHA256SUMS \
  | grep -i "linux-x86_64" \
  | grep -i "en-US" \
  | grep -i "firefox-143.0.4.tar.xz" > ./firefox-143.0.4.tar.xz.sha256sum.txt

sha256sum --check --quiet --warn ./firefox-143.0.4.tar.xz.sha256sum.txt

tar xf ./linux-x86_64/en-US/firefox-143.0.4.tar.xz

mkdir -p ~/bin
rm -rf ~/bin/firefox
cp --recursive ./firefox ~/bin/

exit 0

# ----- end-of: Main logic -----------------------------------------------------
