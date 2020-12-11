#!/bin/bash

folder=$(dirname $0 | xargs realpath)

source "$folder"/include.sh

if ls $HOME/.ssh &> /dev/null; then
	die "$HOME/.ssh folder already exists. Please check and remove previously installed folder."
fi

ln -sf "$folder"/.ssh $HOME/.ssh
chmod 600 ./.ssh/id_rsa
touch "$folder"/.ssh/known_hosts
touch "$folder"/.ssh/authorized_keys

# Simplify ssh-copy-id procedure
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

