import configparser
import os
import sys

IS_LOCAL_DOCKER_SERVER = os.environ.get('IS_LOCAL_DOCKER_SERVER') == 'TRUE'
LOCAL_DOCKER_MODE = os.environ.get('LOCAL_DOCKER_MODE')
DEBUG = True if LOCAL_DOCKER_MODE == 'DEV' else False

ALLOWED_HOSTS = ['localhost', '127.0.0.1']

config = configparser.ConfigParser()
config.read('/home/python3/passwords.ini')
password = config['passwords']['pgsql_python3'].strip()
del config

DATABASES = {
    'default': {
        'ENGINE': 'django.db.backends.postgresql_psycopg2',
        'NAME': 'django',
        'HOST': '127.0.0.1',
        'USER': 'python3',
        'PASSWORD': password,
    }
}

del password
