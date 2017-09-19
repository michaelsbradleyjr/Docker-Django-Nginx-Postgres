#!/usr/bin/env bash
set -x #echo on

echo "deb http://apt.postgresql.org/pub/repos/apt/ xenial-pgdg main" > \
     /etc/apt/sources.list.d/pgdg.list

wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | \
    apt-key add -

apt-get update
apt-get upgrade -y
apt-get install -y \
        libpq-dev \
        postgresql-9.4 \
        postgresql-contrib-9.4 \
        pwgen \
        sqlite3

rm -rf /var/lib/apt/lists/*
