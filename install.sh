#!/usr/bin/env bash

read -p 'Enter your password that encrypts your ssh key: ' SSH_PW
export SSH_PW


proj_root=$( d=$(dirname $0); cd "$d" && pwd)
env python3 -m pip install --user -r $proj_root/requirements.txt
$proj_root/codes/full_install.py $@
