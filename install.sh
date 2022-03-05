#!/usr/bin/env bash

get_python_version() {
	env python3 -V | cut -d ' ' -f2 | grep -Po '\d+\.\d+'
}

lower_than() {
	local lhs=$1
	local rhs=$2

	echo $lhs
	echo $rhs

	test $(echo "$lhs < $rhs" | bc -l) -eq 1
	return $?
}

if lower_than $(get_python_version) "3.6"; then
	env python3 -m pip install --user future-fstrings
fi

read -s -p 'Enter your password that encrypts your ssh key: ' SSH_PW
export SSH_PW


proj_root=$( d=$(dirname $0); cd "$d" && pwd)
env python3 -m pip install --user -r $proj_root/requirements.txt
env python3 $proj_root/code/full_install.py $@
