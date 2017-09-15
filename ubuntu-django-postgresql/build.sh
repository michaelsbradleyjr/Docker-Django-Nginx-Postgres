#!/usr/bin/env bash
set -x #echo on

# app structure
ln -f -s /build/ubuntu-django-postgresql/conf.prod/* -t /home/python3/conf.prod
ln -f -s /build/ubuntu-django-postgresql/conf.dev/* -t /home/python3/conf.dev

# postgresql
adduser --disabled-password --gecos "" --no-create-home python3

# start
ln -f -s /build/ubuntu-django-postgresql/dev.sh /home/python3/dev.sh
ln -f -s /build/ubuntu-django-postgresql/start.sh /home/python3/start.sh

# supervisor
file_prepend () {
    local ed_cmd="1i"
    if [ ! -f "$2" ]; then
        touch "$2"
        ed_cmd="a"
    fi
    printf '%s\n' H "$ed_cmd" "$1" . w | ed -s "$2"
}
rm /home/python3/conf.prod/supervisor.conf
cp /build/ubuntu-django-postgresql/conf.prod/supervisor.conf /home/python3/conf.prod/
file_prepend \
    "$(cat /build/ubuntu-python3-uwsgi-nginx/conf.prod/supervisor.conf)" \
    /home/python3/conf.prod/supervisor.conf
