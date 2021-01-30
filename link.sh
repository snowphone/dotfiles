#!/usr/bin/env bash

folder=$(dirname $0 | xargs realpath)

source "$folder"/include.sh

## Check for root privilege
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

mkdir -p $HOME/.local/bin/

ln -fs "$folder"/scripts/* $HOME/.local/bin/


[ ! -f $HOME/.trueline.sh ] && curl https://raw.githubusercontent.com/petobens/trueline/master/trueline.sh -o $HOME/.trueline.sh
ln -fs "$folder"/.bashrc $HOME/.bashrc					# Deprecated: bashrc
ln -fs "$folder"/.snapshot $HOME/.snapshot				# For tmux prompt
ln -fs "$folder"/.gitconfig  $HOME/.gitconfig			# Global git configuration
ln -fs "$folder"/.zshrc $HOME/.zshrc
ln -fs "$folder"/.p10k.zsh $HOME/.p10k.zsh
ln -fs "$folder"/.mailcap $HOME/.mailcap				# Open text files with vim when using xdg-open
ln -fs "$folder"/.mailcap.order $HOME/.mailcap.order	# Set higher priority to vim

mkdir -p $HOME/.pip
ln -fs "$folder"/pip.conf $HOME/.pip/pip.conf

