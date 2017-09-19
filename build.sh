#!/usr/bin/env bash

if ! type docker &> /dev/null; then
    echo 'the command `docker` must be on a path in $PATH or aliased'
    exit 127
fi

script_path () {
    local scr_path=""
    local dir_path=""
    local sym_path=""
    # get (in a portable manner) the absolute path of the current script
    scr_path=$(cd -P -- "$(dirname -- "$0")" && pwd -P) && scr_path=$scr_path/$(basename -- "$0")
    # if the path is a symlink resolve it recursively
    while [ -h $scr_path ]; do
        # 1) cd to directory of the symlink
        # 2) cd to the directory of where the symlink points
        # 3) get the pwd
        # 4) append the basename
        dir_path=$(dirname -- "$scr_path")
        sym_path=$(readlink $scr_path)
        scr_path=$(cd $dir_path && cd $(dirname -- "$sym_path") && pwd)/$(basename -- "$sym_path")
    done
    echo $scr_path
}

script_dir=$(dirname -- "$(script_path)")
cd $script_dir

echo "Building 0-ubuntu-netselect"
docker build \
       -t 0-ubuntu-netselect \
       -f ./0-ubuntu-netselect/Dockerfile \
       ./0-ubuntu-netselect

echo "Building 1-python3-uwsgi-nginx-with-0"
docker build \
       -t 1-python3-uwsgi-nginx-with-0 \
       -f ./1-python3-uwsgi-nginx-with-0/Dockerfile \
       ./1-python3-uwsgi-nginx-with-0

echo "Building 2-django-postgresql-with-1"
docker build \
       -t 2-django-postgresql-with-1 \
       -f ./2-django-postgresql-with-1/Dockerfile \
       ./2-django-postgresql-with-1

echo "Building 3-mongodb-with-2"
docker build \
       -t 3-mongodb-with-2 \
       -f ./3-mongodb-with-2/Dockerfile \
       ./3-mongodb-with-2
