#!/usr/bin/env bash
set -x #echo on

cd /home/python3/

# check for first-start
if [ ! -f first-start ]; then
    exec conf/first-start.sh
else
    exec conf/start.sh
fi
