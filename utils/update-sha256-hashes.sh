#!/bin/bash

############################################################################
#                                                                          #
# check for common errors                                                  #
#   __shellcheck -s bash ./update-sha256-hashes.sh                         #
#  (remove __ above)                                                       #
#                                                                          #
# see helpful rsources:                                                    #
#   https://bash-prompt.net/guides/bash-help-case-statement/               #
#   https://vaneyckt.io/posts/safer_bash_scripts_with_set_euxo_pipefail/   #
#   https://mywiki.wooledge.org/BashGuide                                  #
#   https://mywiki.wooledge.org/BashFAQ                                    #
#                                                                          #
############################################################################

# adding -x makes Bash print each line before executing it
# set -Eeuxo pipefail
set -Eeuo pipefail

# shellcheck disable=SC2317  # Don't warn about unreachable commands in this function
function hndl_SIGHUP() {
  echo "Unfortunately, the script received SIGHUP..."
  exit 1
}
# shellcheck disable=SC2317  # Don't warn about unreachable commands in this function
function hndl_SIGINT() {
  echo "Unfortunately, the script received SIGINT..."
  exit 1
}
# shellcheck disable=SC2317  # Don't warn about unreachable commands in this function
function hndl_SIGQUIT() {
  echo "Unfortunately, the script received SIGQUIT..."
  exit 1
}
# shellcheck disable=SC2317  # Don't warn about unreachable commands in this function
function hndl_SIGABRT() {
  echo "Unfortunately, the script received SIGABRT..."
  exit 1
}
# shellcheck disable=SC2317  # Don't warn about unreachable commands in this function
function hndl_SIGTERM() {
  echo "Unfortunately, the script received SIGTERM..."
  exit 1
}

# shellcheck disable=SC2317  # Don't warn about unreachable commands in this function
function hndl_EXIT() {
  echo "The script hit an EXIT..."
  exit 0
}
# shellcheck disable=SC2317  # Don't warn about unreachable commands in this function
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

# --------------------------------------------------------------------------

WORKDIR1="$(pwd)"
WORKDIR2="$PWD"
if [ "$WORKDIR1" == "$WORKDIR2" ]; then
  echo "Working directory is '${WORKDIR1}'. Good :-)"
else
  echo "Something strange with working directory."
  exit 1
fi

if [ "$#" -ne 1 ]; then
  echo "You need to pass 1 argument. It should be the name of a directory."
  exit 1
fi

args=("$@")

FOLDER_TO_HASH="${args[0]}"
if [[ -d $FOLDER_TO_HASH ]]; then
  echo "Argument provided '$FOLDER_TO_HASH'. It is a directory. Good :-)"
elif [[ -f $FOLDER_TO_HASH ]]; then
  echo "Argument provided '$FOLDER_TO_HASH'. It is a file, but should be a directory."
  exit 1
else
  echo "Argument provided '$FOLDER_TO_HASH'. No file or directory with such a name."
  exit 1
fi

SHA_SUM_FILE="${FOLDER_TO_HASH}.sha256sum.txt"
if [[ -d $SHA_SUM_FILE ]]; then
  echo "Make sure that '${SHA_SUM_FILE}' is a file."
  exit 1
elif [[ -f $SHA_SUM_FILE ]]; then
  echo "File '${SHA_SUM_FILE}' exists. Good :-)"
else
  echo "Make sure that file '${SHA_SUM_FILE}' exists."
  exit 1
fi

SHA_SUM_FILE_UPDATES="${SHA_SUM_FILE}-updates"
touch "${SHA_SUM_FILE_UPDATES}"
if [[ -f $SHA_SUM_FILE_UPDATES ]]; then
  echo "Created temporary file '${SHA_SUM_FILE_UPDATES}'. Good :-)"
else
  echo "Could not create a temporary file '${SHA_SUM_FILE_UPDATES}'."
  exit 1
fi

find "${FOLDER_TO_HASH}" -type f -newer "${SHA_SUM_FILE}" | sort | uniq > "${SHA_SUM_FILE_UPDATES}"
NEW_HASHES="no"
COUNTER=1
TOTAL="$(wc -l < "${SHA_SUM_FILE_UPDATES}")"

while IFS= read -r line; do

  PATTERN="${line}"
  echo ""
  echo "[${COUNTER} of ${TOTAL}] Looking for '${PATTERN}' in file '${SHA_SUM_FILE}'"

  GREP_STATUS=""
  grep -F "${PATTERN}" "${SHA_SUM_FILE}" && GREP_STATUS="found" || GREP_STATUS="not-found"

  if [ "$GREP_STATUS" == "found" ]; then
    echo "  -> found in sum file - will update HASH"

    LINENUMBER="$( grep -F -n "$PATTERN" "$SHA_SUM_FILE" | cut -d':' -f1 )"
    sed -i "${LINENUMBER}d" "$SHA_SUM_FILE"

    # sha256sum "${PATTERN}" >> "${SHA_SUM_FILE}"
    HASH_INFO="$(sha256sum "${PATTERN}")"
    echo "${HASH_INFO}"
    echo "${HASH_INFO}" >> "${SHA_SUM_FILE}"

    NEW_HASHES="yes"
  elif [ "$GREP_STATUS" == "not-found" ]; then
    echo "  -> new file - will append HASH"

    # sha256sum "${PATTERN}" >> "${SHA_SUM_FILE}"
    HASH_INFO="$(sha256sum "${PATTERN}")"
    echo "${HASH_INFO}"
    echo "${HASH_INFO}" >> "${SHA_SUM_FILE}"

    NEW_HASHES="yes"
	else
		echo "something went wrong while searching"
    exit 1
  fi

  COUNTER=$((COUNTER + 1))

done < "${SHA_SUM_FILE_UPDATES}"

echo ""
rm -rf "${SHA_SUM_FILE_UPDATES}"
echo "Removed temporary file '${SHA_SUM_FILE_UPDATES}'."

if [ "$NEW_HASHES" == "yes" ]; then
  sort --unique "${SHA_SUM_FILE}" -o "${SHA_SUM_FILE}"
  echo "Sorted '${SHA_SUM_FILE}' file (using 'unique' mode)."

  sha256sum "${SHA_SUM_FILE}" > "${SHA_SUM_FILE}.sha"
  echo "Generated '${SHA_SUM_FILE}.sha' file."
else
  echo "No files to hash."
fi

exit 0
