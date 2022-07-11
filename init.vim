set runtimepath^=~/.vim runtimepath+=~/.vim/afterglow
let &packpath = &runtimepath
source ~/.vimrc

" Synchronize clipboard
" Forked from https://blog.landofcrispy.com/index.php/2021/01/06/clipboard-integration-between-tmux-nvim-zsh-x11-across-ssh-sessions/
" vim -> tmux
source  ~/.clipboard/vimhooks.vim

lua <<EOF
	require("nvim-treesitter.configs").setup {
		ensure_installed = {
			"bash",
			"bibtex",
			"c",
			"cmake",
			"comment",
			"cpp",
			"css",
			"dockerfile",
			"elixir",
			"erlang",
			"go",
			"gomod",
			"graphql",
			"html",
			"java",
			"javascript",
			"jsdoc",
			"json",
			"json5",
			"jsonc",
			"kotlin",
			"latex",
			"lua",
			"make",
			"perl",
			"php",
			"python",
			"regex",
			"rust",
			"scss",
			"toml",
			"typescript",
			"vim",
			"yaml",
		},
		highlight = {
			enable = true,							-- false will disable the whole extension
		additional_vim_regex_highlighting = false,
		},
		indent = { enable = true },

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
