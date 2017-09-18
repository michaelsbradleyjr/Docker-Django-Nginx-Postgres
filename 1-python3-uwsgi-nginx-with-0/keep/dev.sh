#!/usr/bin/env bash
set -x #echo on

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
        # start python3's built-in web server
        cd /home/python3/
        python3 -m http.server 8000
    fi
fi
