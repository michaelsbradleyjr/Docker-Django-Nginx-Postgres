#!/usr/bin/env bash
set -x #echo on

if [ ! -f /home/python3/app-name ]; then
    cp /build/ubuntu-python3-uwsgi-nginx/app-name /home/python3/app/app-name
fi

app_name="$(cat /home/python3/app/app-name)"

sed -i "s|appname|$app_name|g" /home/python3/uwsgi.ini
mkdir -p /home/python3/app/$app_name

wsgipy_path="$(find /home/python3/app/$app_name/ -name wsgi.py)"

if [ -z "$wsgipy_path" ]; then
    cp /build/ubuntu-python3-uwsgi-nginx/wsgi.py /home/python3/app/$app_name/
fi

touch /home/python3/first-start

# pass control (back) to app's start script
exec /home/python3/start.sh
