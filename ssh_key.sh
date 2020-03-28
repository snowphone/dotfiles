#!/bin/bash

## Check for accessibility
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

#sshkey 생성
$sudo ssh-keygen -A

mkdir ~/.ssh/
chmod 700 ~/.ssh/
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

