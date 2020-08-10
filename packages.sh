#!/bin/bash

#include functions
source ./include.sh

# Parse arguments
ALLOWED_DISTS=(debian redhat)

while [[ $# -gt 0 ]]; do 
	case $1 in
		-h|--help)
			printf "Usage: $0 [--help|-h] [--latex|-l] [--boost|-b] [--java|-j] [--typescript] [--rust|-r] [--misc|-m] [--all|-a]\n"
			printf "\t-h|--help\tPrint help message\n"
			printf "\t-a|--all\tInstall everything below\n"
			printf "\t-l|--latex\tInstall texlive-full\n\t\t\tIt may require you to interactively input some information\n"
			printf "\t-b|--boost\tInstall libboost-all-dev\n"
			printf "\t-j|--java\tInstall maven and openjdk 14, 11, 9 or 8\n"
			printf "\t--typescript\tInstall typescript\n"
			printf "\t-r|--rust\tInstall rust\n"
			printf "\t-m|--misc\tInstall some miscellaneous stuffs\n"
			printf "\t-t|--transmission\tInstall transmission-daemon\n"
			printf "\n"
			exit 0
			;;
		-l|--latex)
			needLatex=true
			;;
		-b|--boost)
			needBoost=true
			;;
		-j|--java)
			needJava=true
			;;
		-d|--dist)
			dist="$2"
			shift
			;;
		-m|--misc)
			needMisc=true
			;;
		-t|--transmission)
			needTransmission=true
			;;
		--typescript)
			needTypescript=true
			;;
		-r|--rust)
			needRust=true
			;;
		-a|--all)
			needLatex=true
			needBoost=true
			needJava=true
			needMisc=true
			needTransmission=true
			needTypescript=true
			needRust=true
			;;
		*)
			echo "Unknown parameter passed: $1"
			echo "If you need some help, try $0 --help"
			;;
	esac
	shift
done


# Check mandatory arguments
if ! (printf '%s\0' "${ALLOWED_DISTS[@]}" | grep -xq "$dist"); then 
	echo "'$dist' is invalid input"
	echo "You must set --dist value to one of '${ALLOWED_DISTS[@]}'"
	echo "Try $0 --help if you need more information"
	echo ""
	exit 1
fi
###### Parsing is done ######


## Check for root privilege
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

################################################
################# Main phase ###################
################################################

border "Entering package installaion phase"


## Change apt repository to kakao mirror
if [[ $dist == "debian" ]]; then
	printf "Changing mirror site to much faster one... "
	measure \
		$sudo sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list \; \
		$sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list \; \
		$sudo sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

	echo "Add a new repository for Vim 8"
	printf "Updating apt repository... " 
	measure $sudo apt update\; \
		$sudo apt-get install -y software-properties-common\; \
		$sudo apt update
	printf "Adding a new repository named jonathonf/vim... "
	measure $sudo add-apt-repository -y ppa:jonathonf/vim
	printf "Adding a new repository for nodejs... "
	if !(curl --version &> /dev/null); then
		$sudo apt update &> /dev/null && $sudo apt install -y curl &> /dev/null
	fi
	if [[ -n $sudo ]]; then
		measure curl -sL https://deb.nodesource.com/setup_12.x \| sudo -E bash -
	else
		measure curl -sL https://deb.nodesource.com/setup_12.x \| bash -
	fi

	if [[ -n $needJava && $needJava == true ]]; then
		printf "Adding a new repository named for gradle... "
		measure $sudo add-apt-repository ppa:cwchien/gradle
	fi
fi


if [[ $dist == "debian" ]]; then
	pkgs=( \
		build-essential gdb less tar vim git gcc curl rename wget tmux make gzip zip unzip \
		exuberant-ctags cmake clang-format \
		python3-dev python3 python3-pip \
		bfs tree htop ripgrep silversearcher-ag \
		bear sshpass w3m traceroute git-extras \
		neofetch \
		nodejs npm \
		clang-9 clang-tools-9 clangd-9
	)
	if [[ -n $needLatex && $needLatex == true ]]; then
		echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections
		pkgs+=(texlive-full ttf-mscorefonts-installer)
	fi

	if [[ -n $needBoost && $needBoost == true ]]; then
		pkgs+=(libboost-all-dev)
	fi

	if [[ -n $needJava && $needJava == true ]]; then
		pkgs+=(maven gradle openjdk-14-jdk)
	fi

	if [[ -n $needTransmission && $needTransmission == true ]]; then
		pkgs+=( transmission-daemon )
	fi
	
	if [[ -n $needMisc && $needMisc == true ]]; then
		printf "Adding a new repository for some miscellaneous things... "
		measure $sudo apt-get install -y software-properties-common \; \
			$sudo add-apt-repository -y ppa:ytvwld/asciiquarium
		pkgs+=( parallel figlet lolcat toilet img2pdf)
	fi

	printf "Apt updating... "
	measure $sudo apt update

	failedList=()
	while (( ${#pkgs[@]} )) 	# While !pkgs.empty()
	do
		pkg=${pkgs[0]}			# Get head
		pkgs=( "${pkgs[@]:1}" )	# Pop head

		printf "Installing $pkg... "

		if ! measure $sudo apt install -qy $pkg; then
			failedList+=($pkg)

			if [[ $pkg == "clang-9" ]]; then
				pkgs+=("clang-8")
			elif [[ $pkg == "clang-tools-9" ]]; then
				pkgs+=("clang-tools-8")
			elif [[ $pkg == "openjdk-14-jdk" ]]; then
				pkgs+=("openjdk-11-jdk")
			elif [[ $pkg == "openjdk-11-jdk" ]]; then
				pkgs+=("openjdk-9-jdk")
			elif [[ $pkg == "openjdk-9-jdk" ]]; then
				pkgs+=("openjdk-8-jdk")
			fi
		fi
	done

	if [[ ${#failedList[@]} -gt 0 ]]; then
		echo "${failedList[@]}" >> install_failed.log
	fi

elif [[ $dist == "redhat" ]]; then
	$sudo yum groupinstall -y "Development Tools"
	$sudo yum install -y \
		tar vim git gcc curl wget tmux make gzip zip unzip \
		clang clang-tools-extra ctags cmake \
		python3 python3*-devel python3-pip \
		tree htop \
		gzip gem \
		nodejs npm

	if [[ -n $needLatex && $needLatex == true ]]; then
		$sudo yum install -y texlive-*
	fi

	if [[ -n $needBoost && $needBoost == true ]]; then
		$sudo yum install -y boost-*
	fi

	if [[ -n $needJava && $needJava == true ]]; then
		$sudo yum install -y maven java-11-openjdk java-11-openjdk-devel
	fi
fi

printf "Installing pudb, a python debugger... "
mkdir $HOME/.pip
ln -fs "$(pwd)"/pip.conf $HOME/.pip/pip.conf
measure pip3 install --user pudb youtube-dl

if [[ -n $needLatex && $needLatex == true ]]; then
	printf "Refreshing fonts... "
	measure $sudo fc-cache -f -v
fi

if clang-9 --version &> /dev/null; then
	printf "Aliasing clang and clangd... "
	measure $sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 10 \; \
		$sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-9 10
elif clang-8 --version &> /dev/null; then
	printf "Aliasing clang and clangd... "
	measure $sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8 10\; \
		$sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-8 10
fi

if [[ -n $needTypescript && $needTypescript == true ]]; then
	printf "Installing typescript modules... "
	measure $sudo npm install -g typescript pkg ts-node 
fi

if [[ -n $needRust && $needRust == true ]]; then
	printf "Installing rust... "
	measure 'curl https://sh.rustup.rs -sSf | sh -s -- -y'
fi


printf "Installing mdless... "
# Install markdown viewer
measure $sudo gem install mdless



border "Package installation phase completed! 😉"
printf "\n\n"

