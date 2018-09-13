#!/bin/bash

#.bashrc 설정
folder=$(pwd)

ln -fs $(pwd)/.bashrc ~/.bashrc
source ~/.bashrc

#.vimrc 설정
ln -sf $(pwd)/.vimrc ~/.vimrc

#ssh server 설정
sudo sed -i 's/#\?Port 22/Port 2222/' /etc/ssh/sshd_config
sudo sed -i 's/UsePrivilegeSeparation */UsePrivilegeSeparation no/' /etc/ssh/sshd_config
sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

#sshkey 생성
sudo ssh-keygen -A

mkdir ~/.ssh/
chmod 700 ~/.ssh/
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys 
 
#링크 설정
cd ~
ln -fs /mnt/c/Users/mjo97/OneDrive\ -\ 홍익대학교/ ~/hongik/
ln -fs /mnt/c/Users/mjo97/Downloads/ ~/
ln -fs /mnt/c/Users/mjo97/Dropbox/Documents/ ~/

#apt 저장소를 국내로 변경
sudo sed -i 's/kr.archive.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list
sudo sed -i 's/archive.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/ftp.daumkakao.com/g' /etc/apt/sources.list


#필요한 프로그램 설치
sudo apt install -y build-essential exuberant-ctags libboost-all-dev cmake clang-format \
	python3-dev python3 python3-dev python-pip python3-pip \
	bear gzip make vim sshpass tmux unzip git zip w3m wget m4 \
	openjdk-8-jdk-headless


#vim 설정
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c VundleUpdate -c quitall

#YouCompleteMe 설치
cd ~/.vim/bundle/YouCompleteMe
python3 ./install.py --clang-completer --java-completer 
cd ~
ln -fs ~/dotfiles/.ycm_extra_conf.py ~/.vim/
