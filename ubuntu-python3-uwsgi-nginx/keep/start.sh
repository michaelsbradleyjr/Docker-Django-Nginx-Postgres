#!/usr/bin/env bash
set -x #echo on

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
        # start services
        /usr/bin/supervisord -n
    fi
fi
