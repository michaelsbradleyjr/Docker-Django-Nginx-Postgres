#!/usr/bin/env bash
set -x #echo on

# app structure
find /build/3-mongodb-with-2/ -type f | grep -i \.sh$ | \
    parallel chmod +x
if [[ ! -z "$(ls /build/3-mongodb-with-2/conf/)" ]]; then
    ln -f -s /build/3-mongodb-with-2/conf/* -t /home/python3/conf
fi
if [[ ! -z "$(ls /build/3-mongodb-with-2/conf-dev/)" ]]; then
    ln -f -s /build/3-mongodb-with-2/conf-dev/* -t /home/python3/conf-dev
fi
if [[ ! -z "$(ls /build/3-mongodb-with-2/supervisor/)" ]]; then
    ln -f -s /build/3-mongodb-with-2/supervisor/* -t /home/python3/conf/supervisor
fi
if [[ ! -z "$(ls /build/3-mongodb-with-2/supervisor-dev/)" ]]; then
    ln -f -s /build/3-mongodb-with-2/supervisor-dev/* -t /home/python3/conf-dev/supervisor
fi
