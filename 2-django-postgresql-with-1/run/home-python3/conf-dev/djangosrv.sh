#!/usr/bin/env bash

source ~python3/envs/app/bin/activate
cd ~python3/app
python manage.py runserver 0.0.0.0:8000
deactivate
