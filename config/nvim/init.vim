set runtimepath^=~/.vim runtimepath+=~/.vim/afterglow
let &packpath = &runtimepath
source ~/.vimrc

" Synchronize clipboard
" Forked from https://blog.landofcrispy.com/index.php/2021/01/06/clipboard-integration-between-tmux-nvim-zsh-x11-across-ssh-sessions/
" vim -> tmux
source  ~/.clipboard/vimhooks.vim

lua require('init')
