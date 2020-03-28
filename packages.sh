#!/bin/bash

# Parse arguments
ALLOWED_DISTS=(debian redhat)

function handle_error {
	pkgs=$1
	pkg=$2

	echo "failed!"

	if [[ $pkg == "clang-9" ]]; then
		pkgs+=("clang-8")
	elif [[ $pkg == "clang-tools-9" ]]; then
		pkgs+=("clang-tools-8" "clangd-8")
	elif [[ $pkg == "openjdk-11-jdk" ]]; then
		pkgs+=("openjdk-9-jdk")
	fi
}

while [[ $# -gt 0 ]]; do 
	case $1 in
		-h|--help)
			printf "Usage: $0 [--help|-h] [--latex|-l] [--boost|-b] [--java|-j]\n"
			printf "\t-h|--help\tPrint help message\n"
			printf "\t-l|--latex\tInstall texlive-full\n\t\t\tIt may require you to interactively input some information\n"
			printf "\t-b|--boost\tInstall libboost-all-dev\n"
			printf "\t-j|--java\tInstall maven and openjdk 11 or 9"
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


# Auxiliary functions
## Check for accessibility
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

# Main phase
## Change apt repository to kakao mirror
if [[ $dist == "debian" ]]; then
	$sudo sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
	$sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list
	$sudo sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

	version=$(cat /proc/version)
	if [[ "$version" == *"Ubuntu"* && "$version" == *"16.04"* ]]; then
		echo "Add a new repository for Vim 8"
		echo "Update apt" && $sudo apt update &> /dev/null
		$sudo apt-get install -y software-properties-common &> /dev/null
		$sudo apt update &> /dev/null
		echo "Add a new repository named jonathonf/vim"
		$sudo add-apt-repository -y ppa:jonathonf/vim &> /dev/null
	fi
fi


if [[ $dist == "debian" ]]; then
	$sudo apt update &> /dev/null

	pkgs=( \
		build-essential tar vim git gcc curl rename wget tmux make gzip zip unzip \
		exuberant-ctags cmake clang-format \
		python3-dev python3 python-pip python3-pip \
		bfs tree htop \
		bear gzip sshpass w3m traceroute git-extras \
		transmission-daemon \
		figlet youtube-dl lolcat img2pdf screenfetch \
		nodejs npm \
		clang-9 clang-tools-9 clangd-9
	)
	if [[ -n $needLatex && $needLatex == true ]]; then
		pkgs+=(texlive-full)
	fi

	if [[ -n $needBoost && $needBoost == true ]]; then
		pkgs+=(libboost-all-dev)
	fi

	if [[ -n $needJava && $needJava == true ]]; then
		pkgs+=(maven openjdk-11-jdk)
	fi


	for pkg in ${pkgs[@]}
	do
		printf "Installing $pkg... "
		($sudo apt install -qy $pkg &> /dev/null && echo "done!") || handle_error
	done
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

if clang-9 --version &> /dev/null; then
	$sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-9 10
	$sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-9 10
elif clang-8 --version &> /dev/null; then
	$sudo update-alternatives --install /usr/bin/clang clang /usr/bin/clang-8 10
	$sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-8 10
fi

printf "Installing typescript modules... "
($sudo npm install -g typescript pkg ts-node &> /dev/null && echo "done!") || echo "failed!"

printf "Installing mdless... "
# Install markdown viewer
($sudo gem install mdless &> /dev/null && echo "done!") || echo "failed!"

# Install fzf
printf "Installing fzf..."
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf &> /dev/null
~/.fzf/install --all &> /dev/null
printf " done!\n"

