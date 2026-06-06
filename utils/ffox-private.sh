#!/bin/bash

################################################################################
#                                                                              #
# This script is part of a collection of useful Bash scripts.                  #
#                                                                              #
# Script: ffox-private.sh                                                      #
# Description: Launches Firefox with a fresh new profile. Also, randomizes     #
#              the agent string, as well as starting window size and           #
#              position. Once Firefox is closed, the profile folder is         #
#              deleted. Part of the collection of scripts to work with Firefox #
#              profiles:                                                       #
#                - ffox-add-profile.sh                                         #
#                - ffox-private.sh                                             #
#                - ffox-profile.sh                                             #
#                                                                              #
# Author: Valera Rozuvan                                                       #
# GitHub: https://github.com/valera-rozuvan/bash-scripts                       #
# SPDX-License-Identifier: MIT                                                 #
# Last update: 2025-10-11T18:23:38+03:00                                       #
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

WIN_WIDTH=$((800 + RANDOM % 200))
WIN_HEIGHT=$((600 + RANDOM % 200))
MOZL_USER_AGENT_VERSION=$((111 + RANDOM % 30))
RND_OS_AGENTS=(
  "Macintosh; Intel Mac OS X 10.15;"
  "Windows NT 10.0; Win64; x64;"
  "X11; Linux x86_64;"
  "X11; Ubuntu; Linux x86_64;"
)
RND_INDEX=$(( RANDOM % ${#RND_OS_AGENTS[@]} ))
RND_OS_AGENT="${RND_OS_AGENTS[$RND_INDEX]}"

# multiline string def - see https://stackoverflow.com/questions/23929235 .
MOZL_USER_AGENT=""
MOZL_USER_AGENT+="Mozilla/5.0 (${RND_OS_AGENT} "
MOZL_USER_AGENT+="rv:${MOZL_USER_AGENT_VERSION}.0) "
MOZL_USER_AGENT+="Gecko/20100101 "
MOZL_USER_AGENT+="Firefox/${MOZL_USER_AGENT_VERSION}.0"

HOME_DIRECTORY=$(eval echo "~${USER}")
MOZL_PROFILE_FOLDER="${HOME_DIRECTORY}/custom-mozilla-profiles/random-stuff"

MOZL_WIN_PREF=""
MOZL_WIN_PREF+="{"
  MOZL_WIN_PREF+="\"chrome://browser/content/browser.xhtml\":{"
    MOZL_WIN_PREF+="\"main-window\":{"
      MOZL_WIN_PREF+="\"screenX\":\"0\","
      MOZL_WIN_PREF+="\"screenY\":\"0\","
      MOZL_WIN_PREF+="\"width\":\"${WIN_WIDTH}\","
      MOZL_WIN_PREF+="\"height\":\"${WIN_HEIGHT}\","
      MOZL_WIN_PREF+="\"sizemode\":\"normal\""
    MOZL_WIN_PREF+="}"
  MOZL_WIN_PREF+="}"
MOZL_WIN_PREF+="}"

echo "WIN_WIDTH = ${WIN_WIDTH}"
echo "WIN_HEIGHT = ${WIN_HEIGHT}"
echo "MOZL_USER_AGENT_VERSION = ${MOZL_USER_AGENT_VERSION}"
echo "array RND_OS_AGENTS = ${RND_OS_AGENTS[*]}"
echo "RND_INDEX = ${RND_INDEX}"
echo "RND_OS_AGENT = ${RND_OS_AGENT}"
echo "MOZL_USER_AGENT = ${MOZL_USER_AGENT}"
echo "HOME_DIRECTORY = ${HOME_DIRECTORY}"
echo "MOZL_PROFILE_FOLDER = ${MOZL_PROFILE_FOLDER}"
echo "MOZL_WIN_PREF = ${MOZL_WIN_PREF}"

mkdir -p "${MOZL_PROFILE_FOLDER}"

echo "" > "${MOZL_PROFILE_FOLDER}/user.js"
{
  echo "user_pref(\"general.useragent.override\", \"${MOZL_USER_AGENT}\");"
  echo "user_pref(\"browser.translations.enable\", false);"
  echo "user_pref(\"browser.translations.automaticallyPopup\", false);"
  echo "user_pref(\"browser.shell.checkDefaultBrowser\", false);"
  echo "user_pref(\"browser.tabs.warnOnClose\", false);"
  echo "user_pref(\"browser.tabs.warnOnCloseOtherTabs\", false);"
  echo "user_pref(\"browser.showQuitWarning\", false);"
  echo "user_pref(\"dom.disable_beforeunload\", true);"
  echo "user_pref(\"browser.warnOnQuit\", false);"
  echo "user_pref(\"browser.warnOnQuitShortcut\", false);"
  echo "user_pref(\"sidebar.revamp\", false);"
  echo "user_pref(\"startup.homepage_welcome_url\", \"\");"
  echo "user_pref(\"browser.toolbars.bookmarks.visibility\", \"never\");"
  echo "user_pref(\"datareporting.policy.dataSubmissionPolicyBypassNotification\", true);"
  echo "user_pref(\"browser.sessionstore.resume_from_crash\", false);"
} >> "${MOZL_PROFILE_FOLDER}/user.js"

# also check suggestions https://msfn.org/board/topic/186106-r3dfox-a-modern-firefox-based-web-browser-for-windows-vista-7-and-8/page/9/

echo "${MOZL_WIN_PREF}" > "${MOZL_PROFILE_FOLDER}/xulstore.json"

"${HOME_DIRECTORY}/bin/firefox/firefox" -profile "${MOZL_PROFILE_FOLDER}"
rm -rf "${MOZL_PROFILE_FOLDER}"

exit 0

# ----- end-of: Main logic -----------------------------------------------------
