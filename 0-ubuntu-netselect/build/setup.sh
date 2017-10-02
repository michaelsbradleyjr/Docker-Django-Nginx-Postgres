#!/usr/bin/env bash

wget -O netselect.deb http://http.us.debian.org/debian/pool/main/n/netselect/netselect_0.3.ds1-28+b1_`dpkg --print-architecture`.deb

dpkg -i netselect.deb
rm netselect.deb

chmod +x /docker-container/0-ubuntu-netselect/run/netselect-apt.sh
ln -f -s /docker-container/0-ubuntu-netselect/run/netselect-apt.sh /usr/local/bin/netselect-apt
