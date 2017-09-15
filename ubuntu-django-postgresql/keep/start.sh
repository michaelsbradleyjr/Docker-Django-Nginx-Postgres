#!/usr/bin/env bash
set -x #echo on
set -e

if [ -f "/home/python3/app/start.sh" ]; then
    # pass control to app's start script
    exec /home/python3/app/start.sh
else
    # check for first-start
    if [ ! -f /home/python3/first-start ]; then
        if [ -f "/home/python3/app/first-start.sh" ]; then
            # pass control to app's first-start script
            exec /home/python3/app/first-start.sh
        else
            # pass control to first-start script
            exec /home/python3/conf.prod/first-start.sh
        fi
    else
        if [ -f /home/python3/app/pre-launch.sh ]; then
            bash /home/python3/app/pre-launch.sh
        fi

        # start services
        /usr/bin/supervisord -n
    fi
fi
