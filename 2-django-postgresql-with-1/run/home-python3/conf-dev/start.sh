#!/usr/bin/env bash

echo 'Dev Start!'

cd ~python3/

if [ ! -f first-prelaunch-dev ]; then
    conf-dev/first-prelaunch.sh
    conf-dev/prelaunch.sh
else
    conf-dev/prelaunch.sh
fi

settingspy_path="$(find ~python3/app/ -name settings.py)"
app_name=$(basename $(dirname "$settingspy_path"))
ln -f -s ~python3/conf-dev/local_settings.py -t ~python3/app/$app_name/

rm -rf supervisor/conf.d/*
ln -f -s ~python3/conf-dev/supervisor/*.conf -t supervisor/conf.d/

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
