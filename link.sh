#!/usr/bin/env bash

folder=$(dirname $0 | xargs realpath)

source "$folder"/include.sh

## Check for root privilege
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

mkdir -p $HOME/.local/bin/

ln -fs "$folder"/scripts/* $HOME/.local/bin/

# Enable parallelism for tar
ln -sf /usr/bin/lbzip2 $HOME/.local/bin/bzip2
ln -sf /usr/bin/lbzip2 $HOME/.local/bin/bunzip2
ln -sf /usr/bin/lbzip2 $HOME/.local/bin/bzcat
ln -sf /usr/bin/pigz $HOME/.local/bin/gzip
ln -sf /usr/bin/pigz $HOME/.local/bin/gunzip
ln -sf /usr/bin/pigz $HOME/.local/bin/gzcat
ln -sf /usr/bin/pigz $HOME/.local/bin/zcat
ln -sf /usr/bin/pixz $HOME/.local/bin/xz


[ ! -f $HOME/.trueline.sh ] && curl -s https://raw.githubusercontent.com/petobens/trueline/master/trueline.sh -o $HOME/.trueline.sh
ln -fs "$folder"/.bashrc $HOME/.bashrc					# Deprecated: bashrc
ln -fs "$folder"/.gitconfig  $HOME/.gitconfig			# Global git configuration
ln -fs "$folder"/.common.shrc $HOME/.common.shrc
ln -fs "$folder"/.zshrc $HOME/.zshrc
ln -fs "$folder"/.p10k.zsh $HOME/.p10k.zsh
ln -fs "$folder"/.mailcap $HOME/.mailcap				# Open text files with vim when using xdg-open
ln -fs "$folder"/.mailcap.order $HOME/.mailcap.order	# Set higher priority to vim
mkdir -p $HOME/.config/translate-shell
ln -fs "$folder"/init.trans $HOME/.config/translate-shell/init.trans

curl --silent -o $HOME/.dircolors https://raw.githubusercontent.com/huyz/dircolors-solarized/master/dircolors.256dark
# In WSL, folders in Windows storage look as OTHER_WRITABLE, so OTHER_WRITABLE is set as same as DIR.
DIR_COLOR=$(ag -o '(?<=DIR ).+' $HOME/.dircolors)
sed -i "s/^OTHER_WRITABLE .*/OTHER_WRITABLE $DIR_COLOR/" $HOME/.dircolors

mkdir -p $HOME/.pip
ln -fs "$folder"/pip.conf $HOME/.pip/pip.conf
ln -fs $(which pip3) $HOME/.local/bin/pip

