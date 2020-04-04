#!/bin/bash

source ./include.sh

if ls ~/.ssh &> /dev/null; then
	die "~/.ssh folder already exists. Please check and remove previously installed folder."
else
	ln -sf $(pwd)/.ssh ~/.ssh
	chmod 600 ./.ssh/id_rsa
	chmod 600 ./.ssh/CS492_key.pem
	touch $(pwd)/.ssh/known_hosts
	touch $(pwd)/.ssh/authorized_keys
fi

