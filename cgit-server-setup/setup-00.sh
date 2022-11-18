#!/bin/bash

set -o errexit
set -o pipefail

function hndl_SIGHUP() {
  echo "Unfortunately, the script received SIGHUP..."
  exit 1
}
function hndl_SIGINT() {
  echo "Unfortunately, the script received SIGINT..."
  exit 1
}
function hndl_SIGQUIT() {
  echo "Unfortunately, the script received SIGQUIT..."
  exit 1
}
function hndl_SIGABRT() {
  echo "Unfortunately, the script received SIGABRT..."
  exit 1
}
function hndl_SIGTERM() {
  echo "Unfortunately, the script received SIGTERM..."
  exit 1
}

trap hndl_SIGHUP  SIGHUP
trap hndl_SIGINT  SIGINT
trap hndl_SIGQUIT SIGQUIT
trap hndl_SIGABRT SIGABRT
trap hndl_SIGTERM SIGTERM

# ----------------------------------------------------------------------------------------------
echo "[setup-00] step 0"

# How can I get the source directory of a Bash script from within the script itself?
# https://stackoverflow.com/questions/59895/how-can-i-get-the-source-directory-of-a-bash-script-from-within-the-script-itsel
SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$SCRIPT_DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
SCRIPT_DIR="$( cd -P "$( dirname "$SOURCE" )" >/dev/null 2>&1 && pwd )"

PASS_SERVER_HASH="IwiRWPvZx3wS0KbZfbILi7Xpji1t5EL3"
CERT_BCKP_DIR="/home/valera/dev/private/cert-bckp"

SERVER_IP=$(pass servers/$PASS_SERVER_HASH | grep -i "server host" | awk '{ print $3 }')
echo "SERVER_IP = '${SERVER_IP}'"

HOME_VOLUME_ID=$(pass servers/$PASS_SERVER_HASH | grep -i "home volume" | awk '{ print $3 }')
SWAP_VOLUME_ID=$(pass servers/$PASS_SERVER_HASH | grep -i "swap volume" | awk '{ print $3 }')

ADMIN_USER="val"
ADMIN_USER_PSWD=$(pass servers/$PASS_SERVER_HASH | grep -i "user ${ADMIN_USER}" | awk '{ print $3 }')
ADMIN_USER_HOME_DIR="/home/val"
ADMIN_USER_SSH_KEY_HASH=$(pass servers/$PASS_SERVER_HASH | grep -i "ssh hash ${ADMIN_USER}" | awk '{ print $4 }')
ADMIN_USER_SSH_KEY_PSWD=$(pass ssh_keys/"${ADMIN_USER_SSH_KEY_HASH}" | grep -i 'pswd' | awk '{ print $3 }')
ADMIN_USER_SSH_PUBLIC_KEY=$(pass ssh_keys/"${ADMIN_USER_SSH_KEY_HASH}" | head -n 6 | tail -n 1)

SSH_ASKPASS="${SCRIPT_DIR}"/ssh-give-pass.sh ssh-add ~/.ssh/"${ADMIN_USER_SSH_KEY_HASH}"/ed25519 <<< "${ADMIN_USER_SSH_KEY_PSWD}"

ROOT_USER="root"
ROOT_USER_PSWD=$(pass servers/$PASS_SERVER_HASH | grep -i "user ${ROOT_USER}" | awk '{ print $3 }')
ROOT_USER_HOME_DIR="/root"
ROOT_USER_SSH_KEY_HASH=$(pass servers/$PASS_SERVER_HASH | grep -i "ssh hash ${ROOT_USER}" | awk '{ print $4 }')
ROOT_USER_SSH_KEY_PSWD=$(pass ssh_keys/"${ROOT_USER_SSH_KEY_HASH}" | grep -i 'pswd' | awk '{ print $3 }')

SSH_ASKPASS="${SCRIPT_DIR}"/ssh-give-pass.sh ssh-add ~/.ssh/"${ROOT_USER_SSH_KEY_HASH}"/ed25519 <<< "${ROOT_USER_SSH_KEY_PSWD}"

GIT_USER="git2"
GIT_USER_PSWD=$(pass servers/$PASS_SERVER_HASH | grep -i "user ${GIT_USER}" | awk '{ print $3 }')
GIT_USER_HOME_DIR="/home/git2"
GIT_USER_SSH_KEY_HASH=$(pass servers/$PASS_SERVER_HASH | grep -i "ssh hash ${GIT_USER}" | awk '{ print $4 }')
GIT_USER_SSH_KEY_PSWD=$(pass ssh_keys/"${GIT_USER_SSH_KEY_HASH}" | grep -i 'pswd' | awk '{ print $3 }')
GIT_USER_SSH_PUBLIC_KEY=$(pass ssh_keys/"${GIT_USER_SSH_KEY_HASH}" | head -n 6 | tail -n 1)

SSH_ASKPASS="${SCRIPT_DIR}"/ssh-give-pass.sh ssh-add ~/.ssh/"${GIT_USER_SSH_KEY_HASH}"/ed25519 <<< "${GIT_USER_SSH_KEY_PSWD}"

ssh-keygen -f /home/valera/.ssh/known_hosts -R "${SERVER_IP}" > /dev/null 2>&1

# ----------------------------------------------------------------------------------------------
echo "[setup-00] step 1"

rsync \
    -rvz \
    --info=progress2 \
    --checksum \
    -e "ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -p 22 -i ~/.ssh/${ROOT_USER_SSH_KEY_HASH}/ed25519" \
    --progress \
    "${SCRIPT_DIR}"/setup-01.sh \
    $ROOT_USER@"${SERVER_IP}":$ROOT_USER_HOME_DIR

# ----------------------------------------------------------------------------------------------
echo "[setup-00] step 2"

ssh \
    -o ConnectTimeout=10 \
    -o StrictHostKeyChecking=no \
    -p 22 \
    -i ~/.ssh/"${ROOT_USER_SSH_KEY_HASH}"/ed25519 \
    $ROOT_USER@"${SERVER_IP}" \
    "sed -i \"/PermitUserEnvironment/d\" /etc/ssh/sshd_config && echo \"PermitUserEnvironment yes\" | tee -a /etc/ssh/sshd_config > /dev/null && systemctl restart ssh"

rm -rf "${SCRIPT_DIR}"/.env
touch "${SCRIPT_DIR}"/.env
tee -a "${SCRIPT_DIR}"/.env > /dev/null << EOF
HOME_VOLUME_ID=${HOME_VOLUME_ID}
SWAP_VOLUME_ID=${SWAP_VOLUME_ID}
ROOT_USER=${ROOT_USER}
ROOT_USER_PSWD=${ROOT_USER_PSWD}
ROOT_USER_HOME_DIR=${ROOT_USER_HOME_DIR}
ADMIN_USER=${ADMIN_USER}
ADMIN_USER_PSWD=${ADMIN_USER_PSWD}
ADMIN_USER_SSH_PUBLIC_KEY=${ADMIN_USER_SSH_PUBLIC_KEY}
ADMIN_USER_HOME_DIR=${ADMIN_USER_HOME_DIR}
GIT_USER=${GIT_USER}
GIT_USER_PSWD=${GIT_USER_PSWD}
GIT_USER_SSH_PUBLIC_KEY=${GIT_USER_SSH_PUBLIC_KEY}
GIT_USER_HOME_DIR=${GIT_USER_HOME_DIR}
EOF

# ----------------------------------------------------------------------------------------------
echo "[setup-00] step 3"

rsync \
    -rvz \
    --info=progress2 \
    --checksum \
    -e "ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -p 22 -i ~/.ssh/${ROOT_USER_SSH_KEY_HASH}/ed25519" \
    --progress \
    "${SCRIPT_DIR}"/.env \
    $ROOT_USER@"${SERVER_IP}":$ROOT_USER_HOME_DIR/.ssh/environment

# ----------------------------------------------------------------------------------------------
echo "[setup-00] step 4"

ssh \
    -o ConnectTimeout=10 \
    -o StrictHostKeyChecking=no \
    -p 22 \
    -i ~/.ssh/"${ROOT_USER_SSH_KEY_HASH}"/ed25519 \
    $ROOT_USER@"${SERVER_IP}" \
    "chmod u+x ${ROOT_USER_HOME_DIR}/setup-01.sh && ${ROOT_USER_HOME_DIR}/setup-01.sh"

echo "Will wait 60 seconds for server to reboot..."
printf "1, "
sleep 1
for i in {2..59}; do
    printf "%s, " "${i}"
    sleep 1
done
printf "60\n"
sleep 1

# ----------------------------------------------------------------------------------------------
echo "[setup-00] step 5"

rsync \
    -rvz \
    --info=progress2 \
    --checksum \
    -e "ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -p 22 -i ~/.ssh/${ADMIN_USER_SSH_KEY_HASH}/ed25519" \
    "${CERT_BCKP_DIR}"/cgit_server_cert_bckp \
    $ADMIN_USER@"${SERVER_IP}":$ADMIN_USER_HOME_DIR

# ----------------------------------------------------------------------------------------------
echo "[setup-00] step 6"

rsync \
    -rvz \
    --info=progress2 \
    --checksum \
    -e "ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -p 22 -i ~/.ssh/${ADMIN_USER_SSH_KEY_HASH}/ed25519" \
    "${SCRIPT_DIR}"/configs \
    $ADMIN_USER@"${SERVER_IP}":$ADMIN_USER_HOME_DIR

# ----------------------------------------------------------------------------------------------
echo "[setup-00] step 7"

rsync \
    -rvz \
    --info=progress2 \
    --checksum \
    -e "ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -p 22 -i ~/.ssh/${ADMIN_USER_SSH_KEY_HASH}/ed25519" \
    "${SCRIPT_DIR}"/.env \
    $ADMIN_USER@"${SERVER_IP}":$ADMIN_USER_HOME_DIR/.ssh/environment

rm -rf "${SCRIPT_DIR}"/.env

# ----------------------------------------------------------------------------------------------
echo "[setup-00] step 8"

declare -a ADMIN_SCRIPT_ARRAY=("setup-02.sh" "setup-03.sh" "setup-04.sh")
for admin_script in "${ADMIN_SCRIPT_ARRAY[@]}"; do
    # ----------------------------------------------------------------------------------------------
    echo "[setup-00]      -> '${admin_script}' upload"

    rsync \
        -rvz \
        --info=progress2 \
        --checksum \
        -e "ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -p 22 -i ~/.ssh/${ADMIN_USER_SSH_KEY_HASH}/ed25519" \
        --progress \
        "${SCRIPT_DIR}"/"${admin_script}" \
        $ADMIN_USER@"${SERVER_IP}":$ADMIN_USER_HOME_DIR

    # ----------------------------------------------------------------------------------------------
    echo "[setup-00]      -> '${admin_script}' exec"

    ssh \
        -o ConnectTimeout=10 \
        -o StrictHostKeyChecking=no \
        -p 22 \
        -i ~/.ssh/"${ADMIN_USER_SSH_KEY_HASH}"/ed25519 \
        $ADMIN_USER@"${SERVER_IP}" \
        "chmod u+x ${ADMIN_USER_HOME_DIR}/${admin_script} && ${ADMIN_USER_HOME_DIR}/${admin_script}"

    # ----------------------------------------------------------------------------------------------
    echo "[setup-00]      -> '${admin_script}' [done]"

    echo "Will wait 60 seconds for server to reboot..."
    printf "1, "
    sleep 1
    for i in {2..59}; do
        printf "%s, " "${i}"
        sleep 1
    done
    printf "60\n\n"
    sleep 1
done

# ----------------------------------------------------------------------------------------------
echo "[setup-00] step 9"

declare -a GIT_REPO_NAMES_ARRAY=(
  "howtos"
  "dotfiles-emacs"
  "bash-scripts"
  "JSTweener"
  "cgitrepos"
  "cgit-server-setup"
)
for git_repo_name in "${GIT_REPO_NAMES_ARRAY[@]}"; do
    REPO_PATH="/home/valera/dev/public/${git_repo_name}"
    cd "${REPO_PATH}"
    git push --force home_git master
done

# ----------------------------------------------------------------------------------------------
echo "[setup-00] step 10"

admin_script="setup-05.sh"

# ----------------------------------------------------------------------------------------------
echo "[setup-00]      -> '${admin_script}' upload"

rsync \
    -rvz \
    --info=progress2 \
    --checksum \
    -e "ssh -o ConnectTimeout=10 -o StrictHostKeyChecking=no -p 22 -i ~/.ssh/${ADMIN_USER_SSH_KEY_HASH}/ed25519" \
    --progress \
    "${SCRIPT_DIR}"/"${admin_script}" \
    $ADMIN_USER@"${SERVER_IP}":$ADMIN_USER_HOME_DIR

# ----------------------------------------------------------------------------------------------
echo "[setup-00]      -> '${admin_script}' exec"

ssh \
    -o ConnectTimeout=10 \
    -o StrictHostKeyChecking=no \
    -p 22 \
    -i ~/.ssh/"${ADMIN_USER_SSH_KEY_HASH}"/ed25519 \
    $ADMIN_USER@"${SERVER_IP}" \
    "chmod u+x ${ADMIN_USER_HOME_DIR}/${admin_script} && ${ADMIN_USER_HOME_DIR}/${admin_script}"

# ----------------------------------------------------------------------------------------------
echo "[setup-00]      -> '${admin_script}' [done]"

# ----------------------------------------------------------------------------------------------
printf "[setup-00] [done]\n\n"

echo "Setup of server is complete! You can now connect via SSH:"
echo "ssh -i /home/valera/.ssh/${ADMIN_USER_SSH_KEY_HASH}/ed25519 -p 22 ${ADMIN_USER}@${SERVER_IP}"

echo -e "\nDone, without errors ;)"
exit 0
