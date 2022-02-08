set runtimepath+=~/.vim,~/.vim/after
set packpath+=~/.vim
source ~/.vimrc


call plug#begin('~/.vim/plugged/')

Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'p00f/nvim-ts-rainbow'


call plug#end()			" required

lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  sync_install = false,
  ignore_install = { }, -- List of parsers to ignore installing
  highlight = {
    enable = true,              -- false will disable the whole extension
    disable = { },  -- list of language that will be disabled
	additional_vim_regex_highlighting = false,
  },

  rainbow = {
	  enable = true,
	  extended_mode = true,
	  max_file_lines = nil,
  },
}
EOF

set foldmethod=expr
set foldexpr=nvim_treesitter#foldexpr()
