#!/usr/bin/env bash
set -x #echo on
set -e

requirements="/home/python3/conf-dev/requirements.txt"
source /home/python3/envs/app/bin/activate
pip3 install -r $requirements
deactivate

settingspy_path="$(find /home/python3/app/ -name settings.py)"
if [ -z "$settingspy_path" ]; then
    if [ -f /home/python3/app/app-name ]; then
        app_name="$(cat /home/python3/app/app-name)"
    fi
    app_name="$(cat /home/python3/conf/app-name)"
else
    app_name=$(basename $(dirname "$settingspy_path"))
fi
mkdir -p /home/python3/app/$app_name

if [ -z "$settingspy_path" ]; then
    source /home/python3/envs/app/bin/activate
    django-admin startproject $app_name /home/python3/app/
    cd /home/python3/app
    python3 manage.py migrate
    cd -
    deactivate
fi
settingspy_path="$(find /home/python3/app/ -name settings.py)"

if [ ! -f /home/python3/passwords.txt ] ; then
    # start pgsql
    /etc/init.d/postgresql start & sleep 5s

    # generate app db password
    pgsql_python3_password=$(pwgen -c -n -1 42)
    echo "pgsql_python3_password = $pgsql_python3_password" > /home/python3/passwords.txt

    # init pgsql
    tempdir=$(mktemp -d)
    cp /home/python3/conf-dev/init.sql $tempdir/
    sed -i "s|password|$pgsql_python3_password|g" $tempdir/init.sql
    chmod -R 775 $tempdir
    su - postgres -c "psql -f $tempdir/init.sql"
    rm $tempdir/init.sql

    # modify django database setting
    sed -i "s|django.db.backends.sqlite3|django.db.backends.postgresql_psycopg2|g" $settingspy_path
    sed -i "s|os.path.join(BASE_DIR, 'db.sqlite3')|'django',\n        'HOST': '127.0.0.1',\n        'USER': 'python3',\n        'PASSWORD': '$pgsql_python3_password'|g" $settingspy_path

    # run migrations against pgsql
    source /home/python3/envs/app/bin/activate
    cd /home/python3/app
    python3 manage.py migrate
    cd -
    deactivate

    # backup data from sqlite
    if [ -f /home/python3/app/db.sqlite3 ] ; then
        source /home/python3/envs/app/bin/activate
        python3 /home/python3/app/manage.py \
                dumpdata -e sessions -e admin -e contenttypes \
                -e auth --natural-primary --natural-foreign --indent=4 \
                > /home/python3/dump.json
        deactivate
    fi
    dump_path="$(find /home/python3/ -name dump.json)"

    # sqlite data migration
    if [ ! -z "$dump_path" ] ; then
        source /home/python3/envs/app/bin/activate
        python3 /home/python3/app/manage.py loaddata $dump_path
        deactivate
    fi

    # stop pgsql
    /etc/init.d/postgresql stop
fi

touch /home/python3/first-start-dev

# pass control (back) to app's dev start script
exec /home/python3/conf-dev/start.sh
