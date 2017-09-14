#!/usr/bin/env bash
set -x #echo on

/build/ubuntu-netselect/netselect.sh

apt-get update
apt-get upgrade -y
apt-get install -y \
        build-essential \
        ca-certificates \
        curl \
        git \
        mg \
        nginx \
        python3-dev \
        python3-venv \
        supervisor \
        vim

rm -rf /var/lib/apt/lists/*
