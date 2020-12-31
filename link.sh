#!/bin/bash
folder=$(dirname $0 | xargs realpath)

mkdir -p $HOME/.local/bin/

ln -fs "$folder"/scripts/* $HOME/.local/bin/

curl https://raw.githubusercontent.com/petobens/trueline/master/trueline.sh -o $HOME/.trueline.sh
ln -fs "$folder"/.bashrc $HOME/.bashrc
ln -fs "$folder"/.snapshot $HOME/.snapshot
ln -fs "$folder"/.gitconfig  $HOME/.gitconfig

mkdir -p $HOME/.pip
ln -fs "$folder"/pip.conf $HOME/.pip/pip.conf

