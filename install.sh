#!/bin/bash

./packages.sh "$@" || echo "Package installation failed" && exit 1


## Check for accessibility
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

folder=$(pwd)

## Check if running in WSL
if df /mnt/c; then
	isWsl=true
else
	isWsl=false
fi


# Main phase

#.bashrc 설정

ln -fs "$folder"/.bashrc ~/.bashrc

#.vimrc 설정
ln -fs "$folder"/.vimrc ~/.vimrc

#ssh server 설정
$sudo sed -i 's/#\?Port 22/Port 2222/' /etc/ssh/sshd_config
$sudo sed -i 's/UsePrivilegeSeparation */UsePrivilegeSeparation no/' /etc/ssh/sshd_config
$sudo sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

#링크 설정
if [[ $isWsl == true ]]; then
	ln -fs /mnt/c/Users/mjo97/OneDrive\ -\ kaist.ac.kr/ ~/kaist
	ln -fs /mnt/c/Users/mjo97/Downloads/ ~/
	ln -fs /mnt/c/Users/mjo97/Dropbox/Documents/ ~/
	ln -fs /mnt/c/Users/mjo97/Videos/ ~/
fi


#sshkey 생성
$sudo ssh-keygen -A

mkdir ~/.ssh/
chmod 700 ~/.ssh/
touch ~/.ssh/authorized_keys
chmod 600 ~/.ssh/authorized_keys

$sudo npm install -g typescript pkg ts-node

# Install markdown viewer
$sudo gem install mdless

#git 설정
"$folder"/git.sh

# Install fzf
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

#transmission 설정
$sudo sed -i 's/"rpc-username": "transmission"/"rpc-username": "snowphone"/g' /etc/transmission-daemon/settings.json
$sudo sed -i 's/"rpc-password": "transmission"/"rpc-password": "gn36kb"/g' /etc/transmission-daemon/settings.json
$sudo sed -i 's/"download-dir": ".*"/"download-dir": "\/home\/snowphone\/Videos"/g' /etc/transmission-daemon/settings.json
$sudo sed -i 's/^{/{\n"rpc-whitelist-enabled": true,\n/g' /etc/transmission-daemon/settings.json

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

#vim 설정
vim -c PlugUpdate -c quitall

#Promptline 설정
$sudo chmod +w ~
vim -c "PromptlineSnapshot ~/.promptline.sh airline" -c quitall

# coc.nvim 설정
ln -sf "$folder"/coc-settings.json ~/.vim/
ln -sf "$folder"/.coc.vimrc ~/
$sudo npm i -g bash-language-server
pip3 install --user 'python-language-server[yapf]' pylint rope jedi yapf
mkdir -p ~/.config/yapf
ln -sf "$folder"/py_style ~/.config/yapf/style
vim -c 'CocInstall -sync coc-python coc-java coc-git coc-markdownlint coc-texlab coc-terminal coc-tsserver' -c quitall


cd ~
printf "Installation complete
Execute the following command to refresh bash shell\n
\tsource ~/.bashrc\n\n"
