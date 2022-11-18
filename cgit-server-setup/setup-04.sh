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
echo "[setup-04] step 1"

sudo rm -rf /etc/letsencrypt
sudo tar zxvf "${ADMIN_USER_HOME_DIR}"/cgit_server_cert_bckp/all_certs.tar.gz -C /

rm -rf "${ADMIN_USER_HOME_DIR}"/cgit_server_cert_bckp

# ----------------------------------------------------------------------------------------------
echo "[setup-04] step 2"

mv "${ADMIN_USER_HOME_DIR}"/configs/clear-varnish-cache.sh "${ADMIN_USER_HOME_DIR}"
mv "${ADMIN_USER_HOME_DIR}"/configs/compare-2-files.sh "${ADMIN_USER_HOME_DIR}"
mv "${ADMIN_USER_HOME_DIR}"/configs/update-cgitrepos-file.sh "${ADMIN_USER_HOME_DIR}"

# ----------------------------------------------------------------------------------------------
echo "[setup-04] step 3"

sudo rm -rf /etc/cgitrc
sudo mv "${ADMIN_USER_HOME_DIR}"/configs/cgit/cgitrc /etc
sudo chown "${ROOT_USER}":"${ROOT_USER}" /etc/cgitrc
sudo chgrp "${ROOT_USER}" /etc/cgitrc
sudo chmod a+r /etc/cgitrc
sudo chmod u-x /etc/cgitrc

sudo rm -rf /usr/lib/cgit/cgit-css
sudo mv "${ADMIN_USER_HOME_DIR}"/configs/cgit/cgit-css /usr/lib/cgit
sudo chown -R "${ROOT_USER}":"${ROOT_USER}" /usr/lib/cgit/cgit-css
sudo chgrp -R "${ROOT_USER}" /usr/lib/cgit/cgit-css
sudo chmod -R a+r /usr/lib/cgit/cgit-css
sudo chmod a+x /usr/lib/cgit/cgit-css

sudo mv "${ADMIN_USER_HOME_DIR}"/configs/cgit/git_user/post_receive_git_hook "${GIT_USER_HOME_DIR}"
sudo chown "${GIT_USER}":"${GIT_USER}" "${GIT_USER_HOME_DIR}"/post_receive_git_hook
sudo chgrp "${GIT_USER}" "${GIT_USER_HOME_DIR}"/post_receive_git_hook
sudo chmod u+x "${GIT_USER_HOME_DIR}"/post_receive_git_hook

rm -rf "${ADMIN_USER_HOME_DIR}"/configs/cgit

# ----------------------------------------------------------------------------------------------
echo "[setup-04] step 4"

sudo rm -rf /etc/lighttpd/lighttpd.conf
sudo mv "${ADMIN_USER_HOME_DIR}"/configs/lighttpd/lighttpd.conf /etc/lighttpd
sudo chown "${ROOT_USER}":"${ROOT_USER}" /etc/lighttpd/lighttpd.conf
sudo chgrp "${ROOT_USER}" /etc/lighttpd/lighttpd.conf
sudo chmod a+r /etc/lighttpd/lighttpd.conf

rm -rf "${ADMIN_USER_HOME_DIR}"/configs/lighttpd

# ----------------------------------------------------------------------------------------------
echo "[setup-04] step 5"

sudo mv "${ADMIN_USER_HOME_DIR}"/configs/fail2ban/customisation.local /etc/fail2ban/jail.d
sudo chown "${ROOT_USER}":"${ROOT_USER}" /etc/fail2ban/jail.d/customisation.local
sudo chgrp "${ROOT_USER}" /etc/fail2ban/jail.d/customisation.local
sudo chmod a+r /etc/fail2ban/jail.d/customisation.local
sudo chmod u-x /etc/fail2ban/jail.d/customisation.local

sudo mv "${ADMIN_USER_HOME_DIR}"/configs/fail2ban/nginx-* /etc/fail2ban/filter.d
sudo chown "${ROOT_USER}":"${ROOT_USER}" /etc/fail2ban/filter.d/nginx-*
sudo chgrp "${ROOT_USER}" /etc/fail2ban/filter.d/nginx-*
sudo chmod a+r /etc/fail2ban/filter.d/nginx-*
sudo chmod u-x /etc/fail2ban/filter.d/nginx-*

rm -rf "${ADMIN_USER_HOME_DIR}"/configs/fail2ban

# ----------------------------------------------------------------------------------------------
echo "[setup-04] step 6"

sudo rm -rf /etc/nginx/nginx.conf
sudo mv "${ADMIN_USER_HOME_DIR}"/configs/nginx/nginx.conf /etc/nginx
sudo chown "${ROOT_USER}":"${ROOT_USER}" /etc/nginx/nginx.conf
sudo chgrp "${ROOT_USER}" /etc/nginx/nginx.conf
sudo chmod a+r /etc/nginx/nginx.conf
sudo chmod u-x /etc/nginx/nginx.conf

rm -rf "${ADMIN_USER_HOME_DIR}"/configs/nginx

# ----------------------------------------------------------------------------------------------
echo "[setup-04] step 7"

sudo rm -rf /etc/varnish/default.vcl
sudo mv "${ADMIN_USER_HOME_DIR}"/configs/varnish/default.vcl /etc/varnish
sudo chown "${ROOT_USER}":"${ROOT_USER}" /etc/varnish/default.vcl
sudo chgrp "${ROOT_USER}" /etc/varnish/default.vcl
sudo chmod a+r /etc/varnish/default.vcl

# TODO: Need to edit the file "/lib/systemd/system/varnish.service", change the exec line to:
#  ExecStart=/usr/sbin/varnishd -j unix,user=vcache -F -a :6081 -T localhost:6082 -f /etc/varnish/default.vcl -S /etc/varnish/secret -s default=malloc,1024m -s static=file,/var/lib/varnish/varnish_storage.bin,4G

rm -rf "${ADMIN_USER_HOME_DIR}"/configs/varnish

# ----------------------------------------------------------------------------------------------
echo "[setup-04] step 8"

sudo usermod --shell /usr/bin/git-shell "${GIT_USER}"
rm -rf "${ADMIN_USER_HOME_DIR}"/configs
chmod -R 700 "${ADMIN_USER_HOME_DIR}"

# ----------------------------------------------------------------------------------------------
echo "[setup-04] step 9"

sudo systemctl enable fail2ban
sudo systemctl start fail2ban

sudo systemctl enable lighttpd
sudo systemctl start lighttpd

sudo systemctl enable varnish
sudo systemctl start varnish

sudo systemctl enable nginx
sudo systemctl start nginx

git config --global init.defaultBranch master
sudo git config --global init.defaultBranch master

git config --global pull.rebase false
sudo git config --global pull.rebase false

declare -a GIT_REPO_NAMES_ARRAY=(
  "howtos"
  "dotfiles-emacs"
  "bash-scripts"
  "JSTweener"
  "cgitrepos"
  "cgit-server-setup"
)
for git_repo_name in "${GIT_REPO_NAMES_ARRAY[@]}"; do
    REPO_PATH="${GIT_USER_HOME_DIR}/${git_repo_name}.git"
    sudo git init --bare "${REPO_PATH}"
    sudo ln -s "${GIT_USER_HOME_DIR}"/post_receive_git_hook "${REPO_PATH}"/hooks/post-receive
    sudo chown -R "${GIT_USER}":"${GIT_USER}" "${REPO_PATH}"
    sudo chgrp -R "${GIT_USER}" "${REPO_PATH}"
    sudo chmod -R a+r "${REPO_PATH}"
done

# ----------------------------------------------------------------------------------------------
echo "[setup-04] step 10"

screen -dmS reboot "${ADMIN_USER_HOME_DIR}/reboot-in-5s.sh"

echo -e "\nDone, without errors ;)"
exit 0
