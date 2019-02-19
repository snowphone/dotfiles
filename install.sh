#!/bin/bash

#.bashrc 설정
folder=$(pwd)

ln -fs $(pwd)/.bashrc ~/.bashrc
source ~/.bashrc

#.vimrc 설정
ln -fs $(pwd)/.vimrc ~/.vimrc

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
ln -fs /mnt/c/Users/mjo97/OneDrive\ -\ 홍익대학교/ ~/hongik/
ln -fs /mnt/c/Users/mjo97/Downloads/ ~/
ln -fs /mnt/c/Users/mjo97/Dropbox/Documents/ ~/
ln -fs /mnt/c/Users/mjo97/Videos/ ~/

#apt 저장소를 국내로 변경
sudo sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
sudo sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

#apt 저장소 갱신
sudo apt update


#필요한 프로그램 설치
sudo apt install -y \
	build-essential clang exuberant-ctags libboost-all-dev cmake clang-format \
	python3-dev python3 python3-dev python-pip python3-pip \
	bear gzip make vim sshpass tmux unzip git zip w3m wget traceroute git-extras \
	maven transmission-daemon

#transmission 설정
sudo sed -i 's/"rpc-username": "transmission"/"rpc-username": "snowphone"/g' /etc/transmission-daemon/settings.json 
sudo sed -i 's/"rpc-password": "transmission"/"rpc-password": "gn36kb"/g' /etc/transmission-daemon/settings.json 
sudo sed -i 's/"download-dir": ".*"/"download-dir": "~\/Vidoes"/g' /etc/transmission-daemon/settings.json 
sudo sed -i 's/^{/{\n"rpc-whitelist-enabled": true,\n' /etc/transmission-daemon/settings.json 

#tmux 설정
ln -fs $(folder)/.tmux.conf ~/
#bind key + C-s, bind key + C-r을 이용해 전체 tmux session들을 저장 및 복구할 수 있다.
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmuxResurrect/


#vim 설정
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c VundleUpdate -c quitall

#YouCompleteMe 설치
python3  ~/.vim/bundle/YouCompleteMe/install.py --clang-completer --java-completer 
ln -fs ~/dotfiles/.ycm_extra_conf.py ~/.vim/
cd ~
