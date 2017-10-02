#!/usr/bin/env bash

echo 'Start!'

cd ~python3/

if [ ! -f first-prelaunch ]; then
    conf/first-prelaunch.sh
    conf/prelaunch.sh
else
    conf/prelaunch.sh
fi

settingspy_path="$(find ~python3/app/ -name settings.py)"
app_name=$(basename $(dirname "$settingspy_path"))
ln -f -s ~python3/conf/local_settings.py -t ~python3/app/$app_name/

rm -rf supervisor/conf.d/*
ln -f -s ~python3/conf/supervisor/*.conf -t supervisor/conf.d/

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
