#!/bin/bash

# Auxiliary functions

function contains {
	# $1: argv(haystack), $2: keyword(needle)
	local shorten=$(printf "%1c" "$2")
	if [[ "$1" == *"--$2"*  ||  "$@" == *"-$shorten"* ]]; then
		return 0
	fi
	return 1
}

function export_clang {
	if clang-9 --version &> /dev/null; then
		$sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 10
		$sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-9 10
	elif clang-8 --version &> /dev/null; then
		$sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8 10
		$sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-8 10
	fi
}

# Prepare phase

if  contains $@, "help"; then
	printf "Usage: $0 [--help|-h] [--latex|-l] [--boost|-b]\n"
	printf "\t--help|-h:\tPrint help message\n"
	printf "\t--latex|-l:\tInstall texlive-full\n\t\t\tIt may require you to interactively input some information\n"
	printf "\t--boost|-b:\tInstall libboost-all-dev\n"
	printf "\n"
	exit 0
fi

if contains $@, "latex"; then
	needLatex=true
fi

if contains $@, "boost"; then
	needBoost=true
fi

## Check for accessibility
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

$sudo apt install -y wget || $sudo yum install -y wget

## screenfetch 
wget -O screenfetch-dev https://git.io/vaHfR
chmod +x screenfetch-dev


## Get distribution
distData=$(./screenfetch-dev)
if echo $distData | grep -i ubuntu > /dev/null; then
	dist="debian"
elif echo $distData | grep -i centos > /dev/null; then
	dist="redhat"
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

#apt 저장소를 국내로 변경
if [[ $dist == "debian" ]]; then
	$sudo sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
	$sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
	$sudo sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

	version=$(cat /proc/version)
	if [[ "$version" == *"Ubuntu"* && "$version" == *"16.04"* ]]; then
		echo "Add a new repository for Vim 8"
		$sudo apt update
		$sudo apt-get install -y software-properties-common
		$sudo apt update
		$sudo add-apt-repository -y ppa:jonathonf/vim
	fi
fi


#필요한 프로그램 설치
if [[ $dist == "debian" ]]; then
	#apt 저장소 갱신
	$sudo apt update

	for pkg in \
		build-essential tar vim git gcc curl rename wget tmux make gzip zip unzip \
		exuberant-ctags cmake clang-format \
		python3-dev python3 python-pip python3-pip \
		bfs tree htop \
		bear gzip sshpass w3m traceroute git-extras \
		maven transmission-daemon \
		figlet youtube-dl lolcat img2pdf screenfetch; do
		$sudo apt install -qy $pkg
	done

	$sudo apt install -y clang-9 clang-tools-9  || $sudo apt install -y clang-8 clang-tools-8
	$sudo apt install -y  openjdk-11-jdk || $sudo apt install -y openjdk-9-jdk

	if [[ -n $needLatex && $needLatex == true ]]; then
		$sudo apt install -y texlive-full
	fi
	if [[ -n $needBoost && $needBoost == true ]]; then
		$sudo apt install -y libboost-all-dev
	fi

	if [[ -z $sudo ]];then
		# Using Debian, as root
		curl -sL https://deb.nodesource.com/setup_13.x | bash -
		apt-get install -y nodejs
	else
		# Using Ubuntu
		curl -sL https://deb.nodesource.com/setup_13.x | sudo -E bash -
		sudo apt-get install -y nodejs
	fi


elif [[ $dist == "redhat" ]]; then
	$sudo yum groupinstall -y "Development Tools"
	$sudo yum install -y \
	tar vim git gcc curl wget tmux make gzip zip unzip \
	clang clang-tools-extra ctags cmake \
	python3 python3*-devel python3-pip \
	tree htop \
	gzip gem \
	maven java-11-openjdk java-11-openjdk-devel \
	nodejs npm

	if [[ -n $needLatex && $needLatex == true ]]; then
		$sudo yum install -y texlive-*
	fi

	if [[ -n $needBoost && $needBoost == true ]]; then
		$sudo yum install -y boost-*
	fi
fi

export_clang

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
git config --global core.autocrlf input
git config --global core.eol lf

git config --global user.name "Junoh Moon"
git config --global user.email "mjo970625@gmail.com"

git config --global merge.tool vimdiff

git config --global diff.tool vimdiff 
git config --global difftool.prompt false

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
