#!/bin/bash

# Include functions
source $(pwd)/include.sh

$(pwd)/packages.sh "$@"	|| die "Package installation failed"
$(pwd)/vim.sh			|| die "Vim configuration is failed"

$(pwd)/git.sh			|| die "git configuration failed" # Global git configuration
$(pwd)/misc.sh			|| die "sshd, transmission, and wsl folder aliasing are failed" # ssh server, transmission, wsl folder linking
$(pwd)/ssh_key.sh		|| die "Failed to generate ssh key" # Generate ssh key
$(pwd)/link.sh			|| die "Aliasing config files is failed" # symbolic links
$(pwd)/tmux.sh			|| die "Failed to setup tmuxResurrect and some config files" # tmuxResurrect and symbolic links about it


cd ~
border "Installation complete"
printf "Execute the following command to refresh bash shell\n
\tsource ~/.bashrc\n\n"
