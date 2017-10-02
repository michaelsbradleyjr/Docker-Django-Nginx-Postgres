#!/usr/bin/env bash

apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv EA312927

echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" | \
    tee /etc/apt/sources.list.d/mongodb-org-3.2.list

apt-get update
apt-get upgrade -y
apt-get install -y \
        mongodb-org=3.2.8 \
        mongodb-org-server=3.2.8 \
        mongodb-org-shell=3.2.8 \
        mongodb-org-mongos=3.2.8 \
        mongodb-org-tools=3.2.8

rm -rf /var/lib/apt/lists/*
