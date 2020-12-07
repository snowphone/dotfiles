#!/bin/bash
folder=$(pwd)

mkdir -p $HOME/.local/bin/

ln -fs "$folder"/scripts/* $HOME/.local/bin/

ln -fs "$folder"/.bashrc $HOME/.bashrc
ln -fs "$folder"/.snapshot $HOME/.snapshot
ln -fs "$folder"/.gitconfig  $HOME/.gitconfig

mkdir -p $HOME/.pip
ln -fs "$folder"/pip.conf $HOME/.pip/pip.conf

