#!/usr/bin/env bash
set -x #echo on

# environment
echo will cite | parallel --bibtex >/dev/null
sed -i "4i export TERM=xterm-color" /root/.bashrc
cat /build/ubuntu-python3-uwsgi-nginx/dot.bashrc >> /root/.bashrc
ln -f -s /build/ubuntu-python3-uwsgi-nginx/dot.dircolors /root/.dircolors
git clone -b custom --depth=1 \
    https://github.com/michaelsbradleyjr/bash-it.git /root/.bash_it
mkdir -p /root/.bash_it/plugins/enabled
ln -s /root/.bash_it/plugins/available/base.plugin.bash \
      /root/.bash_it/plugins/enabled/

# emacs
mkdir -p /root/
ln -f -s /build/ubuntu-python3-uwsgi-nginx/dot.emacs.d /root/.emacs.d

# tmux
ln -f -s /build/ubuntu-python3-uwsgi-nginx/dot.tmux.conf /root/.tmux.conf

# app structure
find /build/ubuntu-python3-uwsgi-nginx/ -type f | grep -i \.sh$ | \
    parallel chmod +x
chmod +x /build/ubuntu-python3-uwsgi-nginx/{dev,start}
mkdir -p /home/python3/{envs,app,conf.prod,conf.dev}
ln -f -s /build/ubuntu-python3-uwsgi-nginx/conf.prod/* -t /home/python3/conf.prod
ln -f -s /build/ubuntu-python3-uwsgi-nginx/conf.dev/* -t /home/python3/conf.dev

# nginx
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.original
rm /etc/nginx/nginx.conf
rm /etc/nginx/sites-available/default
cp /etc/nginx/nginx.conf.original /home/python3/conf.prod/nginx.conf
echo "daemon off;" >> /home/python3/conf.prod/nginx.conf
ln -s /home/python3/conf.prod/nginx.conf /etc/nginx/nginx.conf
ln -s /home/python3/conf.prod/nginx-site.conf /etc/nginx/sites-available/default

# start
ln -s /build/ubuntu-python3-uwsgi-nginx/dev /usr/local/bin/dev
ln -s /build/ubuntu-python3-uwsgi-nginx/start /usr/local/bin/start
ln -s /build/ubuntu-python3-uwsgi-nginx/dev.sh /home/python3/dev.sh
ln -s /build/ubuntu-python3-uwsgi-nginx/start.sh /home/python3/start.sh

# supervisor
ln -s /home/python3/conf.prod/supervisor.conf /etc/supervisor/conf.d/supervisor.conf

# uwsgi
ln -s /home/python3/conf.prod/uwsgi.ini /home/python3/uwsgi.ini
touch /home/python3/touch-reload

# virtual environment
python3 -m venv /home/python3/envs/app
source /home/python3/envs/app/bin/activate
pip3 install -U $(pip3 list | awk '{print $1}' | paste -sd ' ')
pip3 install -r /build/ubuntu-python3-uwsgi-nginx/requirements-build.txt
