#!/bin/bash

folder=$(pwd)
#.bashrc 설정

ln -fs "$folder"/.bashrc ~/.bashrc

#.vimrc 설정
ln -fs "$folder"/.vimrc ~/.vimrc

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
	maven transmission-daemon openjdk-11-jdk \
	figlet youtube-dl lolcat img2pdf rename screenfetch \
	erlang erlang-dev \
	nodejs \
	texlive-full

sudo npm install -g typescript pkg ts-node

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


#transmission 설정
sudo sed -i 's/"rpc-username": "transmission"/"rpc-username": "snowphone"/g' /etc/transmission-daemon/settings.json
sudo sed -i 's/"rpc-password": "transmission"/"rpc-password": "gn36kb"/g' /etc/transmission-daemon/settings.json
sudo sed -i 's/"download-dir": ".*"/"download-dir": "\/home\/snowphone\/Videos"/g' /etc/transmission-daemon/settings.json
sudo sed -i 's/^{/{\n"rpc-whitelist-enabled": true,\n/g' /etc/transmission-daemon/settings.json

#tmux 설정
ln -fs "$folder"/.tmux.conf ~/
#bind key + C-s, bind key + C-r을 이용해 전체 tmux session들을 저장 및 복구할 수 있다.
git clone https://github.com/tmux-plugins/tmux-resurrect ~/.tmuxResurrect/

# Move .snapshot file
ln -fs "$folder"/.snapshot ~/.snapshot

# Change PIP mirror to kakao
mkdir ~/.pip
ln -fs "$folder"/pip.conf ~/.pip/pip.conf

# Set ssh host
ln -fs "$folder"/ssh_config ~/.ssh/config

# ccls 설치
git clone --depth=1 --recursive https://github.com/MaskRay/ccls ~/.ccls
cd ~/.ccls/
wget -c http://releases.llvm.org/8.0.0/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
tar xf clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04.tar.xz
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$PWD/clang+llvm-8.0.0-x86_64-linux-gnu-ubuntu-18.04
sudo cmake --build Release --target install

#vim 설정
vim -c PlugUpdate -c quitall

#Promptline 설정
vim -c "PromptlineSnapshot ~/.promptline.sh airline" -c quitall

# coc.nvim 설정
ln -sf "$folder"/coc-settings.json ~/.vim/
ln -sf "$folder"/.coc.vimrc ~/
sudo npm i -g bash-language-server
pip3 install python-language-server
vim -c 'CocInstall -sync coc-python coc-java coc-git coc-markdownlint coc-texlab coc-terminal coc-tsserver' -c quitall


cd ~
printf "Installation complete
Execute the following command to refresh bash shell\n
\tsource ~/.bashrc\n\n"
