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

# for psql cli usage w/ django pgsql database :: su - django
adduser --disabled-password --gecos "" --no-create-home django

# Model_example content
cp admin.py /home/django/
cp models.py /home/django/

cp init.sql /home/django/
