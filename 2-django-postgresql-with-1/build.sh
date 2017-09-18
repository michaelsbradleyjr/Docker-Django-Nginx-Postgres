#!/usr/bin/env bash
set -x #echo on

# app structure
find /build/2-django-postgresql-with-1/ -type f | grep -i \.sh$ | \
    parallel chmod +x
ln -f -s /build/2-django-postgresql-with-1/conf.prod/* -t /home/python3/conf.prod
ln -f -s /build/2-django-postgresql-with-1/conf.dev/* -t /home/python3/conf.dev

# postgresql
adduser --disabled-password --gecos "" --no-create-home python3

# start
ln -f -s /build/2-django-postgresql-with-1/dev.sh /home/python3/dev.sh
ln -f -s /build/2-django-postgresql-with-1/start.sh /home/python3/start.sh

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
cp /build/2-django-postgresql-with-1/conf.prod/supervisor.conf /home/python3/conf.prod/
file_prepend \
    "$(cat /build/1-python3-uwsgi-nginx-with-0/conf.prod/supervisor.conf)" \
    /home/python3/conf.prod/supervisor.conf
