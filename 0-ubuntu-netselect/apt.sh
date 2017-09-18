#!/usr/bin/env bash
set -x #echo on

apt-get update
apt-get upgrade -y
apt-get install -y \
        locales

cat /build/0-ubuntu-netselect/default_locale > /etc/default/locale
locale-gen --purge "en_US.UTF-8"
dpkg-reconfigure locales

export LANG=en_US.UTF-8

apt-get install -y \
        wget

rm -rf /var/lib/apt/lists/*
