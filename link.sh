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


[ ! -f $HOME/.trueline.sh ] && curl https://raw.githubusercontent.com/petobens/trueline/master/trueline.sh -o $HOME/.trueline.sh
ln -fs "$folder"/.bashrc $HOME/.bashrc					# Deprecated: bashrc
ln -fs "$folder"/.gitconfig  $HOME/.gitconfig			# Global git configuration
ln -fs "$folder"/.zshrc $HOME/.zshrc
ln -fs "$folder"/.p10k.zsh $HOME/.p10k.zsh
ln -fs "$folder"/.mailcap $HOME/.mailcap				# Open text files with vim when using xdg-open
ln -fs "$folder"/.mailcap.order $HOME/.mailcap.order	# Set higher priority to vim
ln -fs "$folder"/init.trans $HOME/.config/translate-shell/init.trans
curl -o $HOME/.dircolors https://raw.githubusercontent.com/arcticicestudio/nord-dircolors/develop/src/dir_colors

mkdir -p $HOME/.pip
ln -fs "$folder"/pip.conf $HOME/.pip/pip.conf
ln -fs $(which pip3) $HOME/.local/bin/pip

