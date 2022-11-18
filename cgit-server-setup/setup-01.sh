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
echo "[setup-01] step 1"

DATA_FOLDER=$(df -h | grep -i "${HOME_VOLUME_ID}" | awk '{ print $6 }')
mkdir -p "${DATA_FOLDER}"/home

# SC2114 - Warning: deletes a system directory.
# https://github.com/koalaman/shellcheck/wiki/SC2114
# shellcheck disable=SC2114
rm -rf /home

ln -s "${DATA_FOLDER}"/home /home

# ----------------------------------------------------------------------------------------------
echo "[setup-01] step 2"

useradd -m "${ADMIN_USER}"
usermod --shell /bin/bash "${ADMIN_USER}"

mkdir -p /home/"${ADMIN_USER}"/.ssh
echo "${ADMIN_USER_SSH_PUBLIC_KEY}" > /home/"${ADMIN_USER}"/.ssh/authorized_keys

chmod -R 700 /home/"${ADMIN_USER}"
chown -R "${ADMIN_USER}":"${ADMIN_USER}" /home/"${ADMIN_USER}"
chgrp -R "${ADMIN_USER}" /home/"${ADMIN_USER}"

# ----------------------------------------------------------------------------------------------
echo "[setup-01] step 3"

useradd -m "${GIT_USER}"
usermod --shell /bin/bash "${GIT_USER}"

mkdir -p /home/"${GIT_USER}"/.ssh
echo "${GIT_USER_SSH_PUBLIC_KEY}" > /home/"${GIT_USER}"/.ssh/authorized_keys

chown -R "${GIT_USER}":"${GIT_USER}" /home/"${GIT_USER}"
chgrp -R "${GIT_USER}" /home/"${GIT_USER}"

# ----------------------------------------------------------------------------------------------
echo "[setup-01] step 4"

echo "${ROOT_USER}:${ROOT_USER_PSWD}" | chpasswd
echo "${ADMIN_USER}:${ADMIN_USER_PSWD}" | chpasswd
echo "${GIT_USER}:${GIT_USER_PSWD}" | chpasswd

echo "${ADMIN_USER} ALL=(ALL) NOPASSWD: ALL" | tee -a /etc/sudoers > /dev/null

# ----------------------------------------------------------------------------------------------
echo "[setup-01] step 5"

rm -rf /etc/ssh_banner
rm -rf /etc/ssh/sshd_config
rm -rf /etc/ssh/ssh_config

tee -a /etc/ssh_banner > /dev/null << EOF
█▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀█
█░░╦─╦╔╗╦─╔╗╔╗╔╦╗╔╗░░█
█░░║║║╠─║─║─║║║║║╠─░░█
█░░╚╩╝╚╝╚╝╚╝╚╝╩─╩╚╝░░█
▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀
EOF

tee -a /etc/ssh/sshd_config > /dev/null << EOF
Port 22
PermitRootLogin no
StrictModes yes
MaxAuthTries 6
MaxSessions 10
ClientAliveInterval 120

PubkeyAuthentication yes
PermitUserEnvironment yes

PasswordAuthentication no
PermitEmptyPasswords no

ChallengeResponseAuthentication no

UsePAM yes

X11Forwarding no
PrintMotd no

AcceptEnv LANG LC_*
Banner /etc/ssh_banner

AllowUsers ${ADMIN_USER} ${GIT_USER}
EOF

tee -a /etc/ssh/ssh_config > /dev/null << EOF
Host *
    SendEnv LANG LC_*
    HashKnownHosts yes
    GSSAPIAuthentication yes
EOF

# ----------------------------------------------------------------------------------------------
echo "[setup-01] step 6"

systemctl restart ssh

# ----------------------------------------------------------------------------------------------
echo "[setup-01] step 7"

rm -rf "${ROOT_USER_HOME_DIR}"/reboot-in-5s.sh
touch "${ROOT_USER_HOME_DIR}"/reboot-in-5s.sh

tee -a "${ROOT_USER_HOME_DIR}"/reboot-in-5s.sh > /dev/null << EOF
#!/bin/bash

touch ~/reboot-in-5s.sh.log

DATE_NOW=\$(date)
echo "[\${DATE_NOW}]"       >> ~/reboot-in-5s.sh.log
echo "Rebooting in 5s ..."  >> ~/reboot-in-5s.sh.log
sleep 5s
echo "Rebooting now ..."    >> ~/reboot-in-5s.sh.log
echo "-------------------"  >> ~/reboot-in-5s.sh.log
echo ""                     >> ~/reboot-in-5s.sh.log
sudo shutdown -r now

exit 0
EOF
chmod u+x "${ROOT_USER_HOME_DIR}"/reboot-in-5s.sh

cp "${ROOT_USER_HOME_DIR}"/reboot-in-5s.sh "${ADMIN_USER_HOME_DIR}"
chown "${ADMIN_USER}":"${ADMIN_USER}" "${ADMIN_USER_HOME_DIR}"/reboot-in-5s.sh
chgrp "${ADMIN_USER}" "${ADMIN_USER_HOME_DIR}"/reboot-in-5s.sh
chmod u+x "${ADMIN_USER_HOME_DIR}"/reboot-in-5s.sh

# ----------------------------------------------------------------------------------------------
echo "[setup-01] step 8"

echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
apt-get update && apt-get install -y screen

# ----------------------------------------------------------------------------------------------
echo "[setup-01] step 9"

screen -dmS reboot "${ROOT_USER_HOME_DIR}/reboot-in-5s.sh"

echo -e "\nDone, without errors ;)"
exit 0
