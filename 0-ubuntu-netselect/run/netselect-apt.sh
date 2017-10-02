#!/usr/bin/env bash

sed -r -i -e "s#http://(archive|security)\.ubuntu\.com/ubuntu/?#$(netselect -v -s1 -t3 `wget -q -O- https://launchpad.net/ubuntu/+archivemirrors | grep -P -B8 "statusUP|statusSIX" | grep -o -P "http://[^\"]*"`|grep -P -o 'http://.+$')#g" /etc/apt/sources.list
