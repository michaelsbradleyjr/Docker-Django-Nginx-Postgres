#!/usr/bin/env bash

apt-get update
apt-get upgrade -y
apt-get install -y \
        wget

rm -rf /var/lib/apt/lists/*
