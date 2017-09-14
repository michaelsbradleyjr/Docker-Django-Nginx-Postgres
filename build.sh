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

echo -e "Building ubuntu-netselect:16.04\n"
docker build \
       -t ubuntu-netselect:16.04 \
       -f ./ubuntu-netselect/Dockerfile \
       ./ubuntu-netselect

echo -e "Building ubuntu-python3-uwsgi-nginx:16.04\n"
docker build \
       -t ubuntu-python3-uwsgi-nginx:16.04 \
       -f ./ubuntu-python3-uwsgi-nginx/Dockerfile \
       ./ubuntu-python3-uwsgi-nginx

echo -e "Building ubuntu-django-postgresql:16.04\n"
docker build \
       -t ubuntu-django-postgresql:16.04 \
       -f ./ubuntu-django-postgresql/Dockerfile \
       ./ubuntu-django-postgresql
