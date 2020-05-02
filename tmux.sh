#!/bin/bash

folder=$(pwd)
#tmux 설정
ln -fs "$folder"/.tmux.conf $HOME/
#bind key + C-s, bind key + C-r을 이용해 전체 tmux session들을 저장 및 복구할 수 있다.
git clone https://github.com/tmux-plugins/tmux-resurrect $HOME/.tmuxResurrect/

