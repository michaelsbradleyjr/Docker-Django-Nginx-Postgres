#!/usr/bin/env bash
set -x #echo on

apt-get update
apt-get upgrade -y
apt-get install -y \
        wget

rm -rf /var/lib/apt/lists/*
