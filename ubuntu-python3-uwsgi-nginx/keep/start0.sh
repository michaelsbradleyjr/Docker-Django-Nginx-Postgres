#!/usr/bin/env bash
set -x #echo on

if [ ! -f /home/python3/app-name ]; then
   cp /build/ubuntu-python3-uwsgi-nginx/app-name /home/python3/app/app-name
fi

app_name="$(cat /home/python3/app/app-name)"

sed -i "s|appname|$app_name|g" /build/ubuntu-python3-uwsgi-nginx/uwsgi.ini
mkdir -p /home/python3/app/$app_name

wsgipy_path="$(find /home/python3/app/$app_name/ -name wsgi.py)"

if [ -z "$wsgipy_path" ]; then
    cp /build/ubuntu-python3-uwsgi-nginx/wsgi.py /home/python3/app/$app_name/
fi

if [ ! -f /home/python3/app/prestart-app.sh ]; then
    cp /build/ubuntu-python3-uwsgi-nginx/prestart-app.sh /home/python3/app/
fi

bash /home/python3/app/prestart-app.sh "$@"

# start services
/usr/bin/supervisord -n
