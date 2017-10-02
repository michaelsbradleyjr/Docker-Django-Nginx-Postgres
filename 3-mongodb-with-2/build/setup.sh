#!/usr/bin/env bash

run=/docker-container/3-mongodb-with-2/run
hp3=~python3

# links
find $run/ -type f | grep -i \.sh$ | parallel chmod +x
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
