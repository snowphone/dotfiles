#!/usr/bin/env bash

read -p 'Enter your password that encrypts your ssh key: ' SSH_PW
export SSH_PW

source <(curl -fsSL https://raw.githubusercontent.com/mkropat/sh-realpath/master/realpath.sh)

proj_root=$(dirname $0 | xargs realpath)
env python3 -m pip install --user -r $proj_root/requirements.txt
$proj_root/codes/full_install.py $@
