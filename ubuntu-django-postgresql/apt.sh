#!/usr/bin/env bash
set -x #echo on

apt-get update
apt-get upgrade -y
apt-get install -y \
        libpq-dev \
        postgresql \
        postgresql-contrib \
        pwgen \
        sqlite3

rm -rf /var/lib/apt/lists/*
