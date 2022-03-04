#!/usr/bin/env bash

read -s -p 'Enter your password that encrypts your ssh key: ' SSH_PW
export SSH_PW


proj_root=$( d=$(dirname $0); cd "$d" && pwd)
env python3 -m pip install --user -r $proj_root/requirements.txt
env python3 $proj_root/code/full_install.py $@
