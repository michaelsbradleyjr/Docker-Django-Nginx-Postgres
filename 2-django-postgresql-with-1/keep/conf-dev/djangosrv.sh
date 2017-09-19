#!/usr/bin/env bash
set -x #echo on

source /home/python3/envs/app/bin/activate
cd /home/python3/app
python3 manage.py runserver 0.0.0.0:8000
deactivate
