#!/usr/bin/env bash

proj_root=$(
	d=$(dirname $0)
	cd "$d" && pwd
)
$proj_root/code/full_install.py $@

cat <<EOF
Try the below to substitute a github protocol:

sed -i 's|https://github.com/snowphone/dotfiles|git@github.com:snowphone/dotfiles|' ${proj_root}/.git/config
EOF
