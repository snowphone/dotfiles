#!/bin/bash

folder=$(dirname $0 | xargs realpath)
#tmux 설정
ln -fs "$folder"/.tmux.conf $HOME/

if [ ! -d ~/.tmux/plugins/tpm ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm && 
		~/.tmux/plugins/tpm/bin/install_plugins && 
		~/.tmux/plugins/tpm/bin/update_plugins all
fi
