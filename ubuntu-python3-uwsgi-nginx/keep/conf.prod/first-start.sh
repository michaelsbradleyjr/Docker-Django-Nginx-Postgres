#!/usr/bin/env bash
set -x #echo on

wsgipy_path="$(find /home/python3/app/ -name wsgi.py)"
if [ -z "$wsgipy_path" ]; then
    if [ ! -f /home/python3/app/app-name ]; then
        cp /home/python3/conf.prod/app-name /home/python3/app/app-name
    fi
    app_name="$(cat /home/python3/app/app-name)"
else
    app_name=$(basename $(dirname "$wsgipy_path"))
fi

sed -i "s|appname|$app_name|g" /home/python3/uwsgi.ini
mkdir -p /home/python3/app/$app_name

if [ -z "$wsgipy_path" ]; then
    cp /build/ubuntu-python3-uwsgi-nginx/wsgi.py /home/python3/app/$app_name/
fi
wsgipy_path="$(find /home/python3/app/ -name wsgi.py)"

touch /home/python3/first-start

# pass control (back) to app's start script
exec /home/python3/start.sh
