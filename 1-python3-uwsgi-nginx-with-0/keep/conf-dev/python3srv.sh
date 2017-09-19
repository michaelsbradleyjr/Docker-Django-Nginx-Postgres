#!/usr/bin/env bash
set -x #echo on

source /home/python3/envs/app/bin/activate
cd /home/python3/
python3 -m http.server 8000
deactivate
