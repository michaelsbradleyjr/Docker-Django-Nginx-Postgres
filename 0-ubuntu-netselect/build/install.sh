#!/usr/bin/env bash

apt-get update

apt-get install -y \
        apt-utils \
        locales

ln -f -s /docker-container/0-ubuntu-netselect/run/default_locale /etc/default/locale
locale-gen --purge "en_US.UTF-8"
dpkg-reconfigure locales

export LANG=en_US.UTF-8

apt-get upgrade -y
apt-get install -y \
        wget

rm -rf /var/lib/apt/lists/*
