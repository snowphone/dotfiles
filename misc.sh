#!/bin/bash

## Check for accessibility
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

folder=$(dirname $0 | xargs realpath)

## Check if running in WSL
if df /mnt/c &> /dev/null; then
	isWsl=true
else
	isWsl=false
fi


# Main phase

#.bashrc 설정
#링크 설정
if [[ $isWsl == true ]]; then
	if [[ ! -L $HOME/kaist ]]; then
		ln -fs /mnt/c/Users/mjo97/OneDrive\ -\ kaist.ac.kr/ $HOME/kaist
	fi
	ln -fs /mnt/c/Users/mjo97/Downloads/ $HOME/
	ln -fs /mnt/c/Users/mjo97/Dropbox/Documents/ $HOME/
	ln -fs /mnt/c/Users/mjo97/Videos/ $HOME/
	if [[ ! -L $HOME/winHome ]]; then
		ln -fs /mnt/c/Users/mjo97/ $HOME/winHome
	fi
fi


#transmission 설정
if transmission-daemon --version &> /dev/null; then
	$sudo sed -i 's/"rpc-username": "transmission"/"rpc-username": "snowphone"/g' /etc/transmission-daemon/settings.json
	$sudo sed -i 's/"rpc-password": "transmission"/"rpc-password": "gn36kb"/g' /etc/transmission-daemon/settings.json
	$sudo sed -i 's/"download-dir": ".*"/"download-dir": "\/home\/snowphone\/Videos"/g' /etc/transmission-daemon/settings.json
	$sudo sed -i 's/^{/{\n"rpc-whitelist-enabled": true,\n/g' /etc/transmission-daemon/settings.json
fi

