set -x #echo on

echo 'First Start!'

wsgipy_path="$(find /home/python3/app/ -name wsgi.py)"
if [ -z "$wsgipy_path" ]; then
    if [ -f /home/python3/app/app-name ]; then
        app_name="$(cat /home/python3/app/app-name)"
    fi
    app_name="$(cat /home/python3/conf/app-name)"
else
    app_name=$(basename $(dirname "$wsgipy_path"))
fi
mkdir -p /home/python3/app/$app_name
sed -i "s|appname|$app_name|g" /home/python3/uwsgi.ini

if [ -z "$wsgipy_path" ]; then
    cp /home/python3/conf/wsgi.py /home/python3/app/$app_name/
fi
wsgipy_path="$(find /home/python3/app/ -name wsgi.py)"

touch /home/python3/first-start

# pass control (back) to app's start script
exec /home/python3/conf/start.sh
