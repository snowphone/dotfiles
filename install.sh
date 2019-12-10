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
ln -fs /mnt/c/Users/mjo97/OneDrive\ -\ kaist.ac.kr/ ~/kaist
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
	build-essential clang clang-tools-8 exuberant-ctags libboost-all-dev cmake clang-format \
	python3-dev python3 python3-dev python-pip python3-pip \
	bear gzip make vim sshpass tmux unzip git zip w3m wget traceroute git-extras \
	bfs tree \
	maven transmission-daemon \
	figlet lolcat img2pdf rename \
	erlang erlang-dev \
	texlive-full

# Install markdown viewer
sudo gem install mdless

#git 설정
git config --global core.autocrlf input
git config --global core.eol lf

git config --global user.name "Junoh Moon"
git config --global user.email "mjo970625@gmail.com"

git config --global merge.tool vimdiff

git config --global diff.tool vimdiff 
git config --global difftool.prompt false


#fzf 설치
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all
source ~/.bashrc

#transmission 설정
sudo sed -i 's/"rpc-username": "transmission"/"rpc-username": "snowphone"/g' /etc/transmission-daemon/settings.json
sudo sed -i 's/"rpc-password": "transmission"/"rpc-password": "gn36kb"/g' /etc/transmission-daemon/settings.json
sudo sed -i 's/"download-dir": ".*"/"download-dir": "\/home\/snowphone\/Videos"/g' /etc/transmission-daemon/settings.json
sudo sed -i 's/^{/{\n"rpc-whitelist-enabled": true,\n/g' /etc/transmission-daemon/settings.json

#tmux 설정
ln -fs $(pwd)/.tmux.conf ~/
#bind key + C-s, bind key + C-r을 이용해 전체 tmux session들을 저장 및 복구할 수 있다.
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmuxResurrect/

# Move .snapshot file
ln -fs $(pwd)/.snapshot ~/.snapshot

# Change PIP mirror to kakao
mkdir ~/.pip
ln -fs $(pwd)/pip.conf ~/.pip/pip.conf

# Set ssh host
ln -fs $(pwd)/ssh_config ~/.ssh/config

#vim 설정
git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
vim -c VundleUpdate -c quitall

#Promptline 설정
vim -c "PromptlineSnapshot ~/.promptline.sh airline" -c quitall


#YouCompleteMe 설치
python3  ~/.vim/bundle/YouCompleteMe/install.py --clangd-completer --java-completer
ln -fs ~/dotfiles/.ycm_extra_conf.py ~/.vim/
cd ~
