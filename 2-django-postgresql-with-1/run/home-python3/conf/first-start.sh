#!/usr/bin/env bash
set -e

echo 'First Start!'

source ~python3/envs/app/bin/activate
pip install -r ~python3/conf/requirements.txt
deactivate

settingspy_path="$(find ~python3/app/ -name settings.py)"
if [ -z "$settingspy_path" ]; then
    app_name="$(cat ~python3/app-name)"
else
    app_name=$(basename $(dirname "$settingspy_path"))
fi
mkdir -p ~python3/app/$app_name
sed -i "s|appname|$app_name|g" ~python3/conf/uwsgi.ini

if [ -z "$settingspy_path" ]; then
    source ~python3/envs/app/bin/activate
    django-admin startproject $app_name ~python3/app/
    cd ~python3/app
    python manage.py migrate
    cd -
    deactivate
fi
settingspy_path="$(find ~python3/app/ -name settings.py)"

if [[ -z "$(grep '# Local Docker Server' $settingspy_path)" ]]; then
    sed -i "s|appname|$app_name|g" ~python3/settings.py.append
    cat ~python3/settings.py.append >> $settingspy_path
fi

if [ ! -f ~python3/passwords.ini ] ; then
    # start pgsql
    /etc/init.d/postgresql start & sleep 5s

    # generate app passwords
    echo "[passwords]" > ~python3/passwords.ini
    pgsql_python3_password=$(pwgen -c -n -1 42)
    echo "pgsql_python3 = $pgsql_python3_password" >> ~python3/passwords.ini
    django_admin_password="$(pwgen -c -n -1 42)"
    echo "django_admin = $django_admin_password" >> ~python3/passwords.ini

    # init pgsql
    tempdir=$(mktemp -d)
    cp ~python3/init.sql $tempdir/
    sed -i "s|password|$pgsql_python3_password|g" $tempdir/init.sql
    chmod -R 775 $tempdir
    su - postgres -c "psql -f $tempdir/init.sql"
    rm $tempdir/init.sql

    # setup static,media directories
    mkdir -p ~python3/app/{media,static}

    # link local_settings.py
    ln -f -s ~python3/conf/local_settings.py -t ~python3/app/$app_name/

    # run migrations against pgsql
    source ~python3/envs/app/bin/activate
    cd ~python3/app
    python manage.py migrate
    echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@localhost', '$django_admin_password')" | python manage.py shell
    cd -
    deactivate

    # backup data from sqlite
    if [ -f ~python3/app/db.sqlite3 ] ; then
        source ~python3/envs/app/bin/activate
        python ~python3/app/manage.py \
                dumpdata -e sessions -e admin -e contenttypes \
                -e auth --natural-primary --natural-foreign --indent=4 \
                > ~python3/dump.json
        deactivate
    fi
    dump_path="$(find ~python3/ -name dump.json)"

    # sqlite data migration
    if [ ! -z "$dump_path" ] ; then
        source ~python3/envs/app/bin/activate
        python ~python3/app/manage.py loaddata $dump_path
        deactivate
    fi

    # stop pgsql
    /etc/init.d/postgresql stop
fi

touch ~python3/first-start

# pass control (back) to app's start script
exec ~python3/conf/start.sh
