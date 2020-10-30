#!/bin/bash

####################################################################################################
#
# ./backup_s.sh SECRET_PASSWORD_STRING [true]
#
# Backup important home directories via SSH.
#
# Variables you need to edit before you can use this script:
#
#   - REMOTE_HOST_IP
#   - REMOTE_HOST_PORT
#   - REMOTE_HOST_USER
#   - REMOTE_BACKUP_FOLDER
#
#   - TEMP_BCKP_FOLDER
#   - BCKP_FOLDER_ARRAY
#
# Also, note, that the script expects at least 1 parameter.
#
#   - 1st param: password string to be used for encrypting archive
#   - 2nd param: if set to "true" (string), script will assume $REMOTE_BACKUP_FOLDER is a git repo;
#                in this case script will create a commit
#
####################################################################################################

REMOTE_HOST_IP="1.1.1.1"
REMOTE_HOST_PORT="21"
REMOTE_HOST_USER="your_user"
REMOTE_BACKUP_FOLDER="/home/some/folder"

TEST_SSH_STRING="test_ssh_string"
ssh_status=$(ssh -o BatchMode=yes -o ConnectTimeout=5 -p ${REMOTE_HOST_PORT} "${REMOTE_HOST_USER}@${REMOTE_HOST_IP}" echo ${TEST_SSH_STRING} 2>&1)
if [[ $ssh_status == *"${TEST_SSH_STRING}" ]] ; then
  echo "SSH works."
else
  echo $ssh_status
  exit 1
fi

if ssh -p $REMOTE_HOST_PORT "${REMOTE_HOST_USER}@${REMOTE_HOST_IP}" stat $REMOTE_BACKUP_FOLDER \> /dev/null 2\>\&1
then
  echo "Remote backup folder exists."
else
  echo "ERROR: Remote backup folder \"${REMOTE_BACKUP_FOLDER}\" does not exist."
  exit 1
fi

PASSWORD=$1
DO_COMMIT=$2

TEMP_BCKP_FOLDER="/home/some/folder"
mkdir -p $TEMP_BCKP_FOLDER

declare -a BCKP_FOLDER_ARRAY=("folder_1" "folder_2" "folder_3")

CURRENT_DATE="$(date +'%Y-%m-%d')"
CURRENT_TIMESTAMP="$(date +'%s')"

for folder in ${BCKP_FOLDER_ARRAY[@]}; do
   7z a -t7z -m0=lzma -mx=9 -mfb=64 -md=32m -ms=on -mhe -p$PASSWORD "${TEMP_BCKP_FOLDER}/${folder}--${CURRENT_DATE}--${CURRENT_TIMESTAMP}.7z" ~/.$folder
done

ssh -p $REMOTE_HOST_PORT "${REMOTE_HOST_USER}@${REMOTE_HOST_IP}" "mkdir -p ${REMOTE_BACKUP_FOLDER}/${CURRENT_DATE}"
rsync -rhvz -e "ssh -p ${REMOTE_HOST_PORT}" --progress ${TEMP_BCKP_FOLDER}/*.7z "${REMOTE_HOST_USER}@${REMOTE_HOST_IP}:${REMOTE_BACKUP_FOLDER}/${CURRENT_DATE}"

if [[ $DO_COMMIT = "true" ]]; then
  ssh -p $REMOTE_HOST_PORT "${REMOTE_HOST_USER}@${REMOTE_HOST_IP}" "cd ${REMOTE_BACKUP_FOLDER} && git add . && git commit -m 'upd'"
fi

rm -rf $TEMP_BCKP_FOLDER

echo "Done!"
exit 0
