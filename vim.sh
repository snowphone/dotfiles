#!/bin/bash

folder=$(dirname $0 | xargs realpath)
source "$folder"/include.sh


border "Entering vim plugins installaion phase"

NVM_PATH="$HOME"/.nvm/nvm.sh
if [ -f $NVM_PATH ]; then
	source $NVM_PATH
	echo "Nvm and npm loaded"
fi

if !(npm --version &> /dev/null) || !(python3 -m pip --version &> /dev/null) || !(vim --version &> /dev/null); then
	echo "To install vim settings, npm, vim, and pip3 is needed"
	echo "Please install them and run it again"
	exit 1
fi

## Check for accessibility
if [[ $(whoami) == "root" ]]; then
	sudo=""
else
	sudo="sudo"
fi

ln -fs "$folder"/.vimrc $HOME/.vimrc

#vim 설정
mkdir -p "$HOME"/.config/coc
vim --not-a-term -c PlugInstall -c quitall

$sudo chmod +w $HOME

ln -sf "$folder"/coc-settings.json $HOME/.vim/
ln -sf "$folder"/.coc.vimrc $HOME/
mkdir -p $HOME/.config/yapf
ln -sf "$folder"/py_style $HOME/.config/yapf/style

measure python3 -m pip install --user yapf

cd $folder

# coc-texlab 설정
## 컴파일시마다 sumatrapdf에게 알려주는 역할
ln -fs "$folder"/.latexmkrc $HOME/.latexmkrc

border "Package vim plugins installation phase completed! 😉"
printf "\n\n"

