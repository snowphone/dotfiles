#!/usr/bin/env bash

read -p 'Enter your password that encrypts your ssh key: ' SSH_PW
export SSH_PW

proj_root=$(dirname $0 | xargs realpath)
$proj_root/codes/full_install.py $@
