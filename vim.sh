#!/bin/bash

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

folder=$(pwd)
ln -fs "$folder"/.vimrc ~/.vimrc

#vim 설정
vim -c PlugUpdate -c quitall

#Promptline 설정
$sudo chmod +w ~
vim -c "PromptlineSnapshot ~/.promptline.sh airline" -c quitall

# coc.nvim 설정
ln -sf "$folder"/coc-settings.json ~/.vim/
ln -sf "$folder"/.coc.vimrc ~/
$sudo npm i -g bash-language-server
python3 -m pip install --user python-language-server[yapf,pylint,rope]
mkdir -p ~/.config/yapf
ln -sf "$folder"/py_style ~/.config/yapf/style
vim -c 'CocInstall -sync coc-python coc-java coc-git coc-markdownlint coc-texlab coc-terminal coc-tsserver' -c quitall

