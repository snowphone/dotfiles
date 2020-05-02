#!/bin/bash

source ./include.sh


border "Entering vim plugins installaion phase"


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
ln -fs "$folder"/.vimrc $HOME/.vimrc

#vim 설정
vim -c PlugUpdate -c quitall

#Promptline 설정
$sudo chmod +w $HOME
vim -c "PromptlineSnapshot $HOME/.promptline.sh airline" -c quitall

# coc.nvim 설정
ln -sf "$folder"/coc-settings.json $HOME/.vim/
ln -sf "$folder"/.coc.vimrc $HOME/
$sudo npm i -g bash-language-server
python3 -m pip install --user python-language-server[yapf,pylint,rope]
mkdir -p $HOME/.config/yapf
ln -sf "$folder"/py_style $HOME/.config/yapf/style
vim -c 'CocInstall -sync coc-python coc-java coc-git coc-markdownlint coc-texlab coc-terminal coc-tsserver' -c quitall

# coc-texlab 설정
## 컴파일시마다 sumatrapdf에게 알려주는 역할
ln -fs "$folder"/.latexmkrc $HOME/.latexmkrc

border "Package vim plugins installation phase completed! 😉"
printf "\n\n"

