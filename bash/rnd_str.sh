#!/bin/bash

SCRIPT_WILL_RUN=0

if [[ "$OSTYPE" == "linux-gnu"* ]] ; then
  SCRIPT_WILL_RUN=1
elif [[ "$OSTYPE" == "darwin"* ]] ; then
  SCRIPT_WILL_RUN=0
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

LENGTH=$1
SILENT=$2

if ! [[ "$LENGTH" =~ ^[0-9]+$ ]] ; then
  echo "ERROR. Please provide a positive integer as 1st arg to this script."
  exit 1
fi

if [[ "$OSTYPE" == "linux-gnu"* ]] ; then
  RND=$(tr -dc A-Za-z0-9 </dev/urandom | head -c $LENGTH ; echo '')
elif [[ "$OSTYPE" == "darwin"* ]] ; then
  RND=$(cat /dev/urandom | env LC_ALL=C tr -dc 'a-zA-Z0-9' | fold -w 32 | head -n 1)
fi

if [[ "$SILENT" = "v" ]] ; then
  echo -e "Verbose mode.\n"

  echo "OSTYPE = ${OSTYPE}"
  echo "LENGTH = ${LENGTH}"
  echo "RND = ${RND}"
else
  echo $RND
fi

exit 0
