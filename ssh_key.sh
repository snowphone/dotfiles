#!/bin/bash

source ./include.sh

if ls ~/.ssh &> /dev/null; then
	die "~/.ssh folder already exists. Please check and remove previously installed folder."
else
	ln -sf $(pwd)/.ssh ~/.ssh
	touch $(pwd)/.ssh/known_hosts
	touch $(pwd)/.ssh/authorized_keys
fi

