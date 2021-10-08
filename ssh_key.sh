#!/bin/bash

folder=$(dirname $0 | xargs realpath)

source "$folder"/include.sh

if [[ -d $HOME/.ssh && ! -L $HOME/.ssh ]]; then
	rm -rf $HOME/.ssh
fi

ln -sf "$folder"/.ssh $HOME/
touch "$folder"/.ssh/known_hosts
touch "$folder"/.ssh/authorized_keys

# Simplify ssh-copy-id procedure
cat $HOME/.ssh/id_rsa.pub >> $HOME/.ssh/authorized_keys

chmod 600 ./.ssh/config
chmod 600 ./.ssh/id_rsa
chmod 600 ./.ssh/authorized_keys
chmod 700 $HOME/.ssh
chmod 700 $folder

# Suppresses no xauth data warning while using ssh -X 
authPath="$HOME/.Xauthority"
if [ ! -f $authPath ]; then
	touch $authPath
	xauth add :0 . `mcookie`
fi


