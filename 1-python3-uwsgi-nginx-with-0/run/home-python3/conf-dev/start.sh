#!/usr/bin/env bash

echo 'Dev Start!'

cd ~python3/

if [ ! -f first-prelaunch-dev ]; then
    conf-dev/first-prelaunch.sh
    conf-dev/prelaunch.sh
else
    conf-dev/prelaunch.sh
fi

rm -rf supervisor/conf.d/*
ln -f -s ~python3/conf-dev/supervisor/*.conf -t supervisor/conf.d/

exec /usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
