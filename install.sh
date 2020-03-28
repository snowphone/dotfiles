#!/bin/bash

function die {
	printf "ERROR: %s\n\n" "$@"
	exit 1
}

./packages.sh "$@"	|| die "Package installation failed"
./vim.sh			|| die "Vim configuration is failed"

./git.sh			|| die "git configuration failed" # Global git configuration
./misc.sh			|| die "sshd, transmission, and wsl folder aliasing are failed" # ssh server, transmission, wsl folder linking
./ssh_key.sh		|| die "Failed to generate ssh key" # Generate ssh key
./link.sh			|| die "Aliasing config files is failed" # symbolic links
./tmux.sh			|| die "Failed to setup tmuxResurrect and some config files" # tmuxResurrect and symbolic links about it


cd ~
printf "Installation complete
Execute the following command to refresh bash shell\n
\tsource ~/.bashrc\n\n"
