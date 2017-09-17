#!/usr/bin/env bash
set -x #echo on

locale-gen --purge "en_US.UTF-8"
cat /build/ubuntu-netselect/default_locale > /etc/default/locale
dpkg-reconfigure locales

wget -O netselect.deb http://http.us.debian.org/debian/pool/main/n/netselect/netselect_0.3.ds1-28+b1_`dpkg --print-architecture`.deb

dpkg -i netselect.deb
rm netselect.deb

chmod +x /build/ubuntu-netselect/netselect.sh
