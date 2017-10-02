#!/usr/bin/env bash

echo 'Start!'

cd ~python3/

if [ ! -f first-prelaunch ]; then
    conf/first-prelaunch.sh
    conf/prelaunch.sh
else
    conf/prelaunch.sh
fi

rm -rf supervisor/conf.d/*
ln -f -s ~python3/conf/supervisor/*.conf -t supervisor/conf.d/

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
