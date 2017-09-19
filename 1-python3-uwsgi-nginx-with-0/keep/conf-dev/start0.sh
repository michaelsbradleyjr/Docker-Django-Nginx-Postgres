#!/usr/bin/env bash
set -x #echo on

cd /home/python3/

# check for first-start
if [ ! -f first-start-dev ]; then
    exec conf-dev/first-start.sh
else
    exec conf-dev/start.sh
fi
