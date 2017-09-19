#!/usr/bin/env bash
set -x #echo on

echo 'Start!'

cd /home/python3/

if [ ! -f first-prelaunch ]; then
    bash conf/first-prelaunch.sh
    bash conf/prelaunch.sh
else
    bash conf/prelaunch.sh
fi

rm -rf supervisor/conf.d/*
ln -f -s /home/python3/conf/supervisor/*.conf -t supervisor/conf.d

/usr/bin/supervisord -n -c /etc/supervisor/supervisord.conf
