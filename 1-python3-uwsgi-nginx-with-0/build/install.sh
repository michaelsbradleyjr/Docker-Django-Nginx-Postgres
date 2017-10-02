#!/usr/bin/env bash

netselect-apt

apt-get update
apt-get upgrade -y
apt-get install -y \
        bash-completion \
        build-essential \
        ca-certificates \
        curl \
        ed \
        emacs-nox \
        git \
        lsof \
        net-tools \
        nginx \
        parallel \
        python3-dev \
        python3-venv \
        screen \
        silversearcher-ag \
        supervisor \
        tmux \
        vim

rm -rf /var/lib/apt/lists/*
