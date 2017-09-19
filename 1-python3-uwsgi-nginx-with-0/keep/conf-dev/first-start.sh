#!/usr/bin/env bash
set -x #echo on

echo 'First Dev Start!'

touch /home/python3/first-start-dev

# pass control (back) to app's dev start script
exec /home/python3/conf-dev/start.sh
