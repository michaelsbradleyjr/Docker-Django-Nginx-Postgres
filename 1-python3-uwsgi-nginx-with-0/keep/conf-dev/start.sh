#!/usr/bin/env bash
set -x #echo on

echo 'Dev Start!'

cd /home/python3/

if [ ! -f first-prelaunch-dev ]; then
    bash conf-dev/first-prelaunch.sh
    bash conf-dev/prelaunch.sh
else
    bash conf-dev/prelaunch.sh
fi

rm -rf supervisor/conf.d/*
ln -f -s /home/python3/conf-dev/supervisor/*.conf -t supervisor/conf.d

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
