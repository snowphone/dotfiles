#!/usr/bin/env bash

folder=$(dirname $0 | xargs realpath)

source "$folder"/include.sh

## Check for root privilege
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

changeShell() {
	local user=$(whoami)
	local shell=$1
	local lineNum=$(grep -n $user /etc/passwd | cut -f1 -d:)
	printf "lineNum: %s\n" "$lineNum"
	local pattern=$(printf '%ds|%s:.*$|%s:%s|' $lineNum $HOME $HOME $shell)
	$sudo sed -ie "$pattern" /etc/passwd
}

"$folder"/link.sh

if exists zsh; then
	if [ $SHELL != $(which zsh) ]; then
		changeShell $(which zsh)
		zsh $HOME/.zshrc
		zsh $HOME/.zgen/init.zsh
	else
		echo "zsh is already a default shell"
	fi
else
	die "zsh does not exist"
fi

printf "Installing nodejs via nvm... "
source "$HOME"/.nvm/nvm.sh
measure nvm install node

printf "Installing typescript related things... "
measure npm install -g typescript ts-node pkg tslib


