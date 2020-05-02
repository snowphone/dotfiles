#!/bin/bash
folder=$(pwd)

ln -fs "$folder"/.bashrc $HOME/.bashrc
ln -fs "$folder"/.snapshot $HOME/.snapshot
ln -fs "$folder"/.gitconfig  $HOME/.gitconfig

mkdir $HOME/.pip
ln -fs "$folder"/pip.conf $HOME/.pip/pip.conf

