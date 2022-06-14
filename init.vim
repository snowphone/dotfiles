set runtimepath^=~/.vim runtimepath+=~/.vim/afterglow
let &packpath = &runtimepath
source ~/.vimrc


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
