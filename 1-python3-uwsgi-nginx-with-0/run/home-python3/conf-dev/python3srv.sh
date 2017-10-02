#!/usr/bin/env bash

source ~python3/envs/app/bin/activate
cd ~python3/
python -m http.server 8000
deactivate
