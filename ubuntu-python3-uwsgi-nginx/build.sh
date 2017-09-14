#!/usr/bin/env bash
set -x #echo on

mkdir -p /home/python3/{envs,app}
ln -s /build/ubuntu-python3-uwsgi-nginx/uwsgi.ini /home/python3/uwsgi.ini
touch /home/python3/touch-reload

# setup a virtual environment for the python3 app
python3 -m venv /home/python3/envs/app
source /home/python3/envs/app/bin/activate
pip3 install -U $(pip3 list | awk '{print $1}' | paste -sd ' ')
pip3 install -r /build/ubuntu-python3-uwsgi-nginx/requirements.txt

# nginx
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.original
rm /etc/nginx/nginx.conf
cp /etc/nginx/nginx.conf.original /build/ubuntu-python3-uwsgi-nginx/nginx.conf
echo "daemon off;" >> /build/ubuntu-python3-uwsgi-nginx/nginx.conf
rm /etc/nginx/sites-available/default

ln -s /build/ubuntu-python3-uwsgi-nginx/nginx.conf /etc/nginx/nginx.conf
ln -s /build/ubuntu-python3-uwsgi-nginx/nginx-site.conf /etc/nginx/sites-available/default

# supervisor
ln -s /build/ubuntu-python3-uwsgi-nginx/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

# start0.sh
ln -s /build/ubuntu-python3-uwsgi-nginx/start0.sh /home/python3/start0.sh
