#!/usr/bin/env bash

cd ~python3/

# check for first-start
if [ ! -f first-start ]; then
    exec conf/first-start.sh
else
    exec conf/start.sh
fi
