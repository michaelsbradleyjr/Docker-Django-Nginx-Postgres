#!/bin/bash

source /home/django/envs/app/bin/activate

SETTING_PATH=`find /home/django/app/ -name settings.py`

# Check is there already exist any django project
if [ -z "$SETTING_PATH" ] ; then

    # Create new django project
    mkdir -p /home/django/app
    django-admin startproject website /home/django/app

    SETTING_PATH=`find /home/django/app/ -name settings.py`

else

    # Install requirements
    if [ -f /home/django/app/requirements.txt ]; then
        pip3 install -r /home/django/app/requirements.txt
    fi

    # Backup data from SQLite
    if [ -f /home/django/app/db.sqlite3 ] ; then
        python3 /home/django/app/manage.py dumpdata -e sessions -e admin -e contenttypes -e auth --natural-primary --natural-foreign --indent=4 > /home/django/app/dump.json
    fi

fi

if [ ! -f /home/django/password.txt ] ; then

    # Start Postgres
    /etc/init.d/postgresql start & sleep 5s

    # Set password
    POSTGRES_DJANGO_PASSWORD=`pwgen -c -n -1 12`
    DJANGO_ADMIN_PASSWORD=`pwgen -c -n -1 12`

    # Output password
    echo -e "POSTGRES_DJANGO_PASSWORD = $POSTGRES_DJANGO_PASSWORD\nDJANGO_ADMIN_PASSWORD = $DJANGO_ADMIN_PASSWORD" > /home/django/password.txt

    # Initialize Postgres
    sed -i "s|password|$POSTGRES_DJANGO_PASSWORD|g" /home/django/init.sql
    su - postgres -c 'psql -f /home/django/init.sql'

    # install Postgres adapter for Python
    pip3 install psycopg2

    # Create model_example app
    mkdir -p /home/django/app/website/model_example/
    django-admin startapp model_example /home/django/app/website/model_example/
    mv /home/django/admin.py /home/django/app/website/model_example/
    mv /home/django/models.py /home/django/app/website/model_example/

    # Add model_example app
    sed -i "s|'django.contrib.staticfiles'|'django.contrib.staticfiles',\n    'website.model_example'|g" $SETTING_PATH

    # Modify database setting to Postgres
    sed -i "s|django.db.backends.sqlite3|django.db.backends.postgresql_psycopg2|g" $SETTING_PATH
    sed -i "s|os.path.join(BASE_DIR, 'db.sqlite3')|'django',\n        'HOST': '127.0.0.1',\n        'USER': 'django',\n        'PASSWORD': '$POSTGRES_DJANGO_PASSWORD'|g" $SETTING_PATH

    # Modify static files setting
    mkdir -p /home/django/app/website/static
    mkdir -p /home/django/app/website/media
    sed -i "s|STATIC_URL = '/static/'|STATIC_URL = '/static/'\n\nSTATIC_ROOT = os.path.join(BASE_DIR, 'website/static')\n\nMEDIA_URL = '/media/'\n\nMEDIA_ROOT = os.path.join(BASE_DIR, 'website/media')|g" $SETTING_PATH

    # Django setting
    python3 /home/django/app/manage.py makemigrations
    python3 /home/django/app/manage.py migrate
    echo yes | python3 /home/django/app/manage.py collectstatic
    echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', '$DJANGO_ADMIN_PASSWORD')" | python3 /home/django/app/manage.py shell

    # Data migration
    DUMP_PATH=`find /home/django/app/ -name dump.json`

    if [ ! -z "$DUMP_PATH" ] ; then
        python3 /home/django/app/manage.py loaddata $DUMP_PATH
    fi

    /etc/init.d/postgresql stop

fi

# Start all the services
/usr/bin/supervisord -n
