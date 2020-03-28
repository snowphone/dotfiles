#!/bin/bash
set -e
./packages.sh "$@" || (echo "Package installation failed" && exit 1)
./vim.sh  || (echo "Vim configuration is failed" && exit 1)

./git.sh # Global git configuration
./misc.sh # ssh server, transmission, wsl folder linking
./link.sh # symbolic links
./tmux.sh # tmuxResurrect and symbolic links about it
./ssh_key.sh # Generate ssh key


cd ~
printf "Installation complete
Execute the following command to refresh bash shell\n
\tsource ~/.bashrc\n\n"
