#!/bin/bash

#.bashrc 설정
folder=$(pwd)

ln -fs $(pwd)/.bashrc ~/.bashrc
source ~/.bashrc

#.vimrc 설정
ln -sf $(pwd)/.vimrc ~/.vimrc

#sshkey 생성
sudo ssh-keygen -A


#apt 저장소를 국내로 변경
sudo sed -i 's/kr.archive.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list
sudo sed -i 's/archive.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list

sudo apt update -y

sudo apt upgrade -y

#필요한 프로그램 설치
sudo apt install -y cmake clang clang-tidy clang-tools clang-format gcc gzip make vim python3 python3-dev python3-pip sshpass tmux unzip git zip w3m wget ctags


#vim 설정
vim 

