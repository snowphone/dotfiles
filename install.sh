#!/bin/bash

folder=$(dirname $0 | xargs realpath)
# Include functions
source "$folder"/include.sh

DEBIAN_FRONTEND=noninteractive "$folder"/packages.sh "$@"	|| die "Package installation failed"
"$folder"/vim.sh			|| die "Vim configuration is failed"

"$folder"/misc.sh			|| die "sshd, transmission, and wsl folder aliasing are failed" # ssh server, transmission, wsl folder linking
"$folder"/ssh_key.sh		|| die "Failed to generate ssh key" # Generate ssh key
"$folder"/link.sh			|| die "Aliasing config files is failed" # symbolic links
"$folder"/tmux.sh			|| die "Failed to setup tmuxResurrect and some config files" # tmuxResurrect and symbolic links about it


cd $HOME
border "Installation complete"
printf "Execute the following command to refresh bash shell\n
\tsource $HOME/.bashrc\n\n"
