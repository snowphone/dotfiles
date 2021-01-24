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

mkdir -p $HOME/.local/bin/

ln -fs "$folder"/scripts/* $HOME/.local/bin/


[ ! -f $HOME/.trueline.sh ] && curl https://raw.githubusercontent.com/petobens/trueline/master/trueline.sh -o $HOME/.trueline.sh
ln -fs "$folder"/.bashrc $HOME/.bashrc			# Deprecated: bashrc
ln -fs "$folder"/.snapshot $HOME/.snapshot		# For tmux prompt
ln -fs "$folder"/.gitconfig  $HOME/.gitconfig	# Global git configuration
ln -fs "$folder"/.zshrc $HOME/.zshrc
ln -fs "$folder"/.p10k.zsh $HOME/.p10k.zsh

mkdir -p $HOME/.pip
ln -fs "$folder"/pip.conf $HOME/.pip/pip.conf

if exists zsh; then
	changeShell $(which zsh)
	zsh $HOME/.zshrc
	zsh $HOME/.zgen/init.zsh
else
	die "zsh not exists"
fi


