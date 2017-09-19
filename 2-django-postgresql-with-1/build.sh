#!/usr/bin/env bash
set -x #echo on

# app structure
find /build/2-django-postgresql-with-1/ -type f | grep -i \.sh$ | \
    parallel chmod +x
ln -f -s /build/2-django-postgresql-with-1/conf/* -t /home/python3/conf
ln -f -s /build/2-django-postgresql-with-1/conf-dev/* -t /home/python3/conf-dev
ln -f -s /build/2-django-postgresql-with-1/supervisor/* -t /home/python3/conf/supervisor
ln -f -s /build/2-django-postgresql-with-1/supervisor-dev/* -t /home/python3/conf-dev/supervisor
rm /home/python3/conf-dev/supervisor/app-python3srv.conf
