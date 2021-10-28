#!/bin/bash

folder=$(dirname $0 | xargs realpath)
#include functions
source "$folder"/include.sh

# Parse arguments
ALLOWED_DISTS=(debian redhat)

while [[ $# -gt 0 ]]; do 
	case $1 in
		-h|--help)
			printf "Usage: $0 [--help|-h] [--latex|-l] [--boost|-b] [--java|-j] [--rust|-r] [--golang|-g] [--misc|-m] [--all|-a]\n"
			printf "\t-h|--help\tPrint help message\n"
			printf "\t-a|--all\tInstall everything below\n"
			printf "\t-l|--latex\tInstall texlive-full\n\t\t\tIt may require you to interactively input some information\n"
			printf "\t-b|--boost\tInstall libboost-all-dev\n"
			printf "\t-j|--java\tInstall maven and openjdk 14, 11, 9 or 8\n"
			printf "\t-r|--rust\tInstall rust\n"
			printf "\t-g|--golang\tInstall golang\n"
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
		-r|--rust)
			needRust=true
			;;
		-g|--golang)
			needGo=true
			;;
		-a|--all)
			needLatex=true
			needBoost=true
			needJava=true
			needMisc=true
			needTransmission=true
			needRust=true
			needGo=true
			;;
		*)
			echo "Unknown parameter passed: $1"
			echo "If you need some help, try $0 --help"
			exit 1
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
	printf "IPv4 preferred in apt\n"
	$sudo sed -riE 's/#\s*(precedence ::ffff:0:0[/]96\s+100)/\1/' /etc/gai.conf 

	export DEBIAN_FRONTEND=noninteractive

	printf "Switching apt repositories to those of Kakao... "
	measure \
		$sudo sed -i 's/kr.archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list \; \
		$sudo sed -i 's/archive.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list \; \
		$sudo sed -i 's/security.ubuntu.com/mirror.kakao.com/g' /etc/apt/sources.list

	echo "Add a repository for the latest Vim"
	printf "  Updating apt repositories... " 
	measure $sudo apt update\; \
		$sudo apt-get install -y software-properties-common\; \
		$sudo apt update
	printf "  Adding a new repository, jonathonf/vim... "
	measure $sudo add-apt-repository -y ppa:jonathonf/vim
	if !(curl --version &> /dev/null); then
		$sudo apt update &> /dev/null && $sudo apt install -y curl &> /dev/null
	fi

	if [[ -n $needJava && $needJava == true ]]; then
		printf "Adding a new repository, cwchien/gradle... "
		measure $sudo add-apt-repository -y ppa:cwchien/gradle
	fi
fi


if [[ $dist == "debian" ]]; then
	pkgs=( \
		build-essential gdb less tar vim git gcc curl rename wget tmux make gzip zip unzip figlet
		zsh python-is-python3
		exuberant-ctags cmake
		python3-dev python3 python3-pip
		bfs tree htop ripgrep silversearcher-ag fd-find rsync
		bear sshpass w3m traceroute git-extras multitail
		neofetch
		poppler-utils # for parsing and reading PDFs
		parallel moreutils num-utils
		lbzip2 pigz pixz p7zip-full
		ffmpeg
		translate-shell dict
	)
	if [[ -n $needLatex && $needLatex == true ]]; then
		echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | $sudo debconf-set-selections
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

	if [[ -n $needGo && $needGo == true ]]; then
		pkgs+=(golang-go)
	fi

	if [ $DISPLAY ]; then
		printf "X11 supported\n"

		pkgs+=( \
		okular
		nautilus # file explorer
		mpv
	)
	fi

	if [[ -n $needMisc && $needMisc == true ]]; then
		printf "Adding a new repository for some miscellaneous things... "
		measure $sudo apt-get install -y software-properties-common \; \
			$sudo add-apt-repository -y ppa:ytvwld/asciiquarium
		pkgs+=( figlet lolcat toilet img2pdf )
	fi

	printf "Updating apt repositories... "
	measure $sudo apt update

	failedList=()
	while (( ${#pkgs[@]} )) 	# While !pkgs.empty()
	do
		pkg=${pkgs[0]}			# Get head
		pkgs=( "${pkgs[@]:1}" )	# Pop head

		printf "Installing $pkg... "

		if ! measure $sudo apt install -qy $pkg; then
			failedList+=($pkg)

			if [[ $pkg == "openjdk-14-jdk" ]]; then
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

mkdir $HOME/.pip
ln -fs "$(pwd)"/pip.conf $HOME/.pip/pip.conf

printf "Installing pudb, a python debugger... "
measure pip3 install --user pudb

printf "Installing youtube-dlc... "
measure pip3 install --user youtube-dlc
ln -sf ~/.local/bin/youtube-dlc ~/.local/bin/youtube-dl

printf "Installing caterpillar, an hls downloader... "
measure pip3 install --user caterpillar-hls 

if [[ -n $needLatex && $needLatex == true ]]; then
	printf "Refreshing fonts... "
	measure $sudo fc-cache -f -v
fi

installClangSuite() {
	latest=13
	for i in $(seq $latest -1 1)
	do
		installList=( clang-$i clang-tools-$i clangd-$i clang-format-$i )
		aliasList=( clang-$i clangd-$i clang-format-$i clang++-$i )
		printf "Installing ${installList[*]}... "
		measure $sudo apt install -qy ${installList[@]} &&
		for package in ${aliasList[@]}
		do
			local name=$(echo $package | sed 's/-[0-9]\+//')
			printf "\n$package is being aliased to $name... "
			priority=$(expr $latest + 1 - $i)
			measure $sudo update-alternatives --install /usr/bin/$name $name /usr/bin/$package $priority
		done &&
			break
	done
}
installClangSuite


if [[ -n $needRust && $needRust == true ]]; then
	printf "Installing rust... "
	measure 'curl https://sh.rustup.rs -sSf | sh -s -- -y'
fi

set_completion() {
	local prog=$1

	mkdir -p $HOME/.local/share/completions
	if exists fdfind; then
		fdfind "${prog}[.]zsh\$" ~/.local/bin --exec ln -sf {} ~/.local/share/completions/_{/.} \;
		fdfind "^_${prog}\$" ~/.local/bin --exec ln -sf {} ~/.local/share/completions \;
	else
		fd "${prog}[.]zsh\$" ~/.local/bin --exec ln -sf {} ~/.local/share/completions/_{/.} \;
		fd "^_${prog}\$" ~/.local/bin --exec ln -sf {} ~/.local/share/completions \;
	fi
}

printf "Installing ripgrep-all... "
measure "get_latest_from_github phiresky/ripgrep-all x86_64-unknown-linux-musl.tar.gz | tar xz -C $HOME/.local/bin --strip 1"
set_completion rga

printf "Installing bottom... "
measure "get_latest_from_github ClementTsang/bottom x86_64-unknown-linux-musl.tar.gz | tar xz -C $HOME/.local/bin"
set_completion btm

printf "Installing gotop... "
measure "get_latest_from_github xxxserxxx/gotop linux_amd64.tgz | tar xz -C $HOME/.local/bin"

printf "Installing bat, a markdown viewer... "
measure "get_latest_from_github sharkdp/bat x86_64-unknown-linux-musl.tar.gz | tar xz -C $HOME/.local/bin --strip 1"
set_completion bat

printf "Installing glow, another markdown viewer... "
measure "get_latest_from_github charmbracelet/glow linux_x86_64.tar.gz | tar xz -C $HOME/.local/bin"
set_completion glow

install_watchman() {
	zippath=/tmp/watchman.zip
	get_latest_from_github facebook/watchman -linux.zip > $zippath && 
		unzip -o $zippath -d /tmp/ && 
		$sudo mkdir -p /usr/local/{bin,lib} /usr/local/var/run/watchman
		$sudo mv /tmp/watchman-*-linux/bin/* /usr/local/bin/ &&
		$sudo mv /tmp/watchman-*-linux/lib/* /usr/local/lib/ && 
		$sudo chmod 755 /usr/local/bin/watchman && 
		$sudo chmod 2777 /usr/local/var/run/watchman
	return $?
}
printf "Installing watchman... "
measure install_watchman

figlet "Package installation phase completed!"
printf "\n\n"

