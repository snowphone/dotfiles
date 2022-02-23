set runtimepath^=~/.vim runtimepath+=~/.vim/afterglow
let &packpath = &runtimepath
source ~/.vimrc


lua <<EOF
  require'nvim-treesitter.configs'.setup {
    ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
    highlight = {
      enable = true,              -- false will disable the whole extension
	  additional_vim_regex_highlighting = false,
    },
    indent = { enable = false },
  
    rainbow = {
  	  enable = true,
  	  extended_mode = true,
  	  max_file_lines = nil,
    },
  }
 
  require("spellsitter").setup {
	  enable = true,
  }
EOF
