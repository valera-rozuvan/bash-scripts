#!/bin/bash

# This Bash script simply installs all dependencies I have ever used on Debian.
# Basically, this is a place for me to keep track of what I need on a new system.
# Mostly useful for an all-purpose dev system.

sudo apt-get install aptitude
sudo aptitude install terminator \
  mc \
  apt-transport-https \
  curl \
  rar \
  unrar \
  vlc \
  ffmpeg \
  mplayer \
  git \
  emacs \
  emacs-bin-common \
  emacs-common \
  emacs-el \
  emacs-common-non-dfsg \
  ufw \
  python3-pip \
  fakeroot \
  linux-source \
  bzip2 \
  build-essential \
  libncurses5-dev \
  ncurses-dev \
  xz-utils \
  libssl-dev \
  bc \
  bison \
  flex \
  gcc \
  pass \
  ntp \
  python-dev \
  python3-dev \
  net-tools \
  geeqie-common \
  geeqie \
  atool \
  p7zip \
  p7zip-full \
  p7zip-rar \
  nomarch \
  arc \
  cpio \
  rpm \
  arj \
  unace \
  lhasa \
  rar \
  unrar \
  zip \
  unzip \
  lzma \
  lzop \
  plzip \
  lzip \
  pbzip2 \
  bzip2 \
  gzip \
  tar \
  file \
  firmware-linux \
  firmware-linux-free \
  firmware-linux-nonfree \
  libelf-dev \
  ldnsutils \
  apt-file \
  dnsutils \
  bind9utils \
  dnsdiag \
  net-tools \
  whois \
  rsync \
  tmux \
  gnupg2 \
  openvpn \
  ntfs-3g \
  gparted \
  openresolv \
  mtools \
  bash-completion \
  fonts-inconsolata \
  automake \
  autoconf

sudo apt-file update

sudo -H pip3 install glances

exit 0
