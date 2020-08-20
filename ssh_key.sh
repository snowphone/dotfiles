#!/bin/bash

source ./include.sh

if ls $HOME/.ssh &> /dev/null; then
	die "$HOME/.ssh folder already exists. Please check and remove previously installed folder."
fi

ln -sf $(pwd)/.ssh $HOME/.ssh
chmod 600 ./.ssh/id_rsa
touch $(pwd)/.ssh/known_hosts
touch $(pwd)/.ssh/authorized_keys

# Simplify ssh-copy-id procedure
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

