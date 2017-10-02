#!/usr/bin/env bash

/etc/init.d/postgresql start & sleep 5s
source /home/python3/envs/app/bin/activate

cd /home/python3/app
settingspy_path="$(find /home/python3/app/ -name settings.py)"

python manage.py startapp model_example
cp conf-dev/admin.py conf-dev/models.py model_example/

sed -i "s|'django.contrib.staticfiles'|'django.contrib.staticfiles',\n    'model_example'|g" $settingspy_path

django_admin_password="$(pwgen -c -n -1 42)"
echo $django_admin_password > /home/python3/app/django-admin-password
echo "from django.contrib.auth.models import User; User.objects.create_superuser('admin', 'admin@example.com', '$django_admin_password')" | python manage.py shell

python manage.py makemigrations
python manage.py migrate

deactivate
/etc/init.d/postgresql stop

touch /home/python3/first-prelaunch-dev
