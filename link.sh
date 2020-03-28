#!/bin/bash
folder=$(pwd)

ln -fs "$folder"/.bashrc ~/.bashrc
ln -fs "$folder"/.snapshot ~/.snapshot

mkdir ~/.pip
ln -fs "$folder"/pip.conf ~/.pip/pip.conf

# Set ssh host
ln -fs "$folder"/ssh_config ~/.ssh/config
