#!/usr/bin/env bash
set -x #echo on

wget -O netselect.deb http://http.us.debian.org/debian/pool/main/n/netselect/netselect_0.3.ds1-28+b1_`dpkg --print-architecture`.deb

dpkg -i netselect.deb
rm netselect.deb

chmod +x /build/0-ubuntu-netselect/netselect.sh
