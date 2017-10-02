#!/usr/bin/env bash

run=/docker-container/1-python3-uwsgi-nginx-with-0/run

adduser --disabled-password --gecos "" python3
usermod -a -G python3 root
hp3=~python3

# get bash-it
git clone -b custom --depth=1 \
    https://github.com/michaelsbradleyjr/bash-it.git $run/dot.bash_it

# user setup
user_setup () {
    local username=$1
    if [[ "$username" != "root" ]]; then
        local h=/home/$username
    else
        local h=~root
    fi
    sed -i "4i export TERM=xterm-color" $h/.bashrc
    cat $run/dot.bashrc >> $h/.bashrc
    cp $run/dot.dircolors $h/.dircolors
    cp -R $run/dot.bash_it $h/.bash_it
    mkdir -p $h/.bash_it/plugins/enabled
    ln -s $h/.bash_it/plugins/available/base.plugin.bash \
       $h/.bash_it/plugins/enabled/
    cp -R $run/dot.emacs.d $h/.emacs.d
    cp $run/dot.tmux.conf $h/.tmux.conf
    [[ "$username" != "root" ]] && chown -R $username:$username $h
}
user_setup root
user_setup python3

# links
echo will cite | parallel --bibtex >/dev/null
find $run/ -type f | grep -i \.sh$ | parallel chmod +x
chmod +x $run/{dev,start}
mkdir -p $hp3/{envs,app,supervisor}
mkdir -p $hp3/supervisor/conf.d

symlink_recur () {
    local src_dir=$1
    local tgt_dir=$2
    local src_lst="$(ls $src_dir 2>/dev/null)"
    if [[ ! -z "$src_lst" ]]; then
        for item in ${src_lst[@]}; do
            if [[ -d "$src_dir/$item" ]]; then
                mkdir -p "$tgt_dir/$item"
                symlink_recur "$src_dir/$item" "$tgt_dir/$item"
            fi
            if [[ -f "$src_dir/$item" ]]; then
                ln -f -s "$src_dir/$item" -t "$tgt_dir/"
            fi
        done
    fi
}

symlink_recur $run/home-python3 $hp3

# nginx
cp /etc/nginx/nginx.conf /etc/nginx/nginx.conf.original
rm /etc/nginx/nginx.conf
rm /etc/nginx/sites-available/default
cp /etc/nginx/nginx.conf.original $hp3/conf/nginx.conf
echo "daemon off;" >> $hp3/conf/nginx.conf
ln -s $hp3/conf/nginx.conf /etc/nginx/nginx.conf
ln -s $hp3/conf/nginx-site.conf /etc/nginx/sites-available/default

# start scripts
ln -s $run/dev /usr/local/bin/dev
ln -s $run/start /usr/local/bin/start

# supervisor
rm -rf /etc/supervisor/conf.d
ln -s $hp3/supervisor/conf.d /etc/supervisor/conf.d

# uwsgi
rm $hp3/conf/uwsgi.ini
cp $run/home-python3/conf/uwsgi.ini $hp3/conf/uwsgi.ini
touch $hp3/touch-reload

# virtual environment
python3 -m venv $hp3/envs/app
source $hp3/envs/app/bin/activate
pip install -U $(pip list | awk '{print $1}' | paste -sd ' ')
deactivate
