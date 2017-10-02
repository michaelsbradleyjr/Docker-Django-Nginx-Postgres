#!/usr/bin/env bash

echo 'First Start!'

source ~python3/envs/app/bin/activate
pip install -r ~python3/conf/requirements.txt
deactivate

wsgipy_path="$(find ~python3/app/ -name wsgi.py)"
if [ -z "$wsgipy_path" ]; then
    app_name="$(cat ~python3/app-name)"
else
    app_name=$(basename $(dirname "$wsgipy_path"))
fi
mkdir -p ~python3/app/$app_name
sed -i "s|appname|$app_name|g" ~python3/conf/uwsgi.ini

if [ -z "$wsgipy_path" ]; then
    cp ~python3/conf/wsgi.py ~python3/app/$app_name/
fi

touch ~python3/first-start

# pass control (back) to app's start script
exec ~python3/conf/start.sh
