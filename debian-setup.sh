#!/bin/bash

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
  emacs25 \
  emacs25-bin-common \
  emacs25-common \
  emacs25-el \
  emacs25-common-non-dfsg \
  ufw \
  python3-pip \
  fakeroot \
  linux-source-4.9 \
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
  ntp

sudo -H pip3 install glances

exit 0
