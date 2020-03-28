#!/bin/bash

## Check for accessibility
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

folder=$(pwd)

## Check if running in WSL
if df /mnt/c &> /dev/null; then
	isWsl=true
else
	isWsl=false
fi


# Main phase

#.bashrc 설정
#ssh server 설정
$sudo sed -i 's/#\?Port 22/Port 2222/' /etc/ssh/sshd_config
$sudo sed -i 's/UsePrivilegeSeparation */UsePrivilegeSeparation no/' /etc/ssh/sshd_config
$sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

#링크 설정
if [[ $isWsl == true ]]; then
	ln -fs /mnt/c/Users/mjo97/OneDrive\ -\ kaist.ac.kr/ ~/kaist
	ln -fs /mnt/c/Users/mjo97/Downloads/ ~/
	ln -fs /mnt/c/Users/mjo97/Dropbox/Documents/ ~/
	ln -fs /mnt/c/Users/mjo97/Videos/ ~/
fi


#transmission 설정
$sudo sed -i 's/"rpc-username": "transmission"/"rpc-username": "snowphone"/g' /etc/transmission-daemon/settings.json
$sudo sed -i 's/"rpc-password": "transmission"/"rpc-password": "gn36kb"/g' /etc/transmission-daemon/settings.json
$sudo sed -i 's/"download-dir": ".*"/"download-dir": "\/home\/snowphone\/Videos"/g' /etc/transmission-daemon/settings.json
$sudo sed -i 's/^{/{\n"rpc-whitelist-enabled": true,\n/g' /etc/transmission-daemon/settings.json

