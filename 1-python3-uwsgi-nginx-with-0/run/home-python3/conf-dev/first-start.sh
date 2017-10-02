#!/usr/bin/env bash

echo 'First Dev Start!'

source ~python3/envs/app/bin/activate
pip install -r ~python3/conf-dev/requirements.txt
deactivate

touch ~python3/first-start-dev

# pass control (back) to app's dev start script
exec ~python3/conf-dev/start.sh
