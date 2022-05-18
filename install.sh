#!/usr/bin/env bash


proj_root=$( d=$(dirname $0); cd "$d" && pwd)
$proj_root/code/full_install.py $@
