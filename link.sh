#!/bin/bash
folder=$(pwd)

ln -fs "$folder"/.bashrc ~/.bashrc
ln -fs "$folder"/.snapshot ~/.snapshot
ln -fs "$folder"/.gitconfig  ~/.gitconfig

mkdir ~/.pip
ln -fs "$folder"/pip.conf ~/.pip/pip.conf

