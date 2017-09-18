#!/usr/bin/env bash
set -x #echo on
set -e

if [ -f "/home/python3/app/dev.sh" ]; then
    # pass control to app's dev start script
    exec /home/python3/app/dev.sh
else
    # check for first-start-dev
    if [ ! -f /home/python3/first-start-dev ]; then
        if [ -f "/home/python3/app/first-start-dev.sh" ]; then
            # pass control to app's first-start-dev script
            exec /home/python3/app/first-start-dev.sh
        else
            # pass control to first-start-dev script
            exec /home/python3/conf.dev/first-start-dev.sh
        fi
    else
        if [ -f /home/python3/app/pre-launch-dev.sh ]; then
            bash /home/python3/app/pre-launch-dev.sh
        fi

        # start django's built-in dev server
        source /home/python3/envs/app/bin/activate
        cd /home/python3/app
        python3 manage.py runserver 0.0.0.0:8000
    fi
fi
