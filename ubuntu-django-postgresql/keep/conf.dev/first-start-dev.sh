#!/usr/bin/env bash
set -x #echo on
set -e

requirements="/home/python3/conf.prod/requirements.txt"
if [ -f /home/python3/app/requirements.txt ]; then
    requirements="/home/python3/app/requirements.txt"
fi
source /home/python3/envs/app/bin/activate
pip3 install -r $requirements
deactivate

settingspy_path="$(find /home/python3/app/ -name settings.py)"
if [ -z "$settingspy_path" ]; then
    if [ ! -f /home/python3/app/app-name ]; then
        cp /home/python3/conf.prod/app-name /home/python3/app/app-name
    fi
    app_name="$(cat /home/python3/app/app-name)"
else
    app_name=$(basename $(dirname "$settingspy_path"))
fi

mkdir -p /home/python3/app/$app_name

if [ -z "$settingspy_path" ]; then
    source /home/python3/envs/app/bin/activate
    django-admin startproject $app_name /home/python3/app/
    cd /home/python3/app
    python3 manage.py migrate
    cd -
    deactivate
fi

if [ -f /home/python3/app/first-pre-launch-dev.sh ]; then
    bash /home/python3/app/first-pre-launch-dev.sh
fi

touch /home/python3/first-start-dev

# pass control (back) to app's dev start script
exec /home/python3/dev.sh
