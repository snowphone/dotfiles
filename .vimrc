" Vim-plug 자동 설치용
" START - Setting up Vundle - the vim plugin bundler
if empty(glob('~/.vim/autoload/plug.vim'))
	silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
				\ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
	autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged/')
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

Plug 'tpope/vim-fugitive', { 'tag': '*' }

Plug 'tommcdo/vim-fugitive-blame-ext'


"256색 콘솔에서 gui용 테마 적용을 가능하게 함
Plug 'godlygeek/csapprox'

"테마(theme)
Plug 'nightsense/carbonized'
Plug 'tomasr/molokai'
Plug 'morhetz/gruvbox'
Plug 'float168/vim-colors-cherryblossom'
Plug 'pineapplegiant/spaceduck', { 'branch': 'main' }
Plug 'NLKNguyen/papercolor-theme'
Plug 'danilo-augusto/vim-afterglow'
Plug 'vigoux/oak'


Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1			  " vim-airline 버퍼 목록 켜기
let g:airline#extensions#tabline#fnamemod = ':t'		  " vim-airline 버퍼 목록 파일명만 출력
let g:airline#extensions#tabline#buffer_nr_show = 1	   " buffer number를 보여준다
let g:airline#extensions#tabline#buffer_nr_format = '%s:' " buffer number format
set laststatus=2 " turn on bottom bar
" Shape of buffer tabs
let g:airline#extensions#tabline#left_sep     = '▌'
let g:airline#extensions#tabline#left_alt_sep = '|'

let g:airline#extensions#whitespace#enabled = 0 		"Disable trailing whitespace warning
let g:airline_theme = 'minimalist'

let g:airline_powerline_fonts = 1
if !exists('g:airline_symbols')
	let g:airline_symbols = {}
endif

" unicode symbols
let g:airline_left_sep = '»'
let g:airline_left_sep = '▶'
let g:airline_right_sep = '«'
let g:airline_right_sep = '◀'
let g:airline_symbols.linenr = '␊'
let g:airline_symbols.linenr = '␤'
let g:airline_symbols.linenr = '¶'
let g:airline_symbols.branch = '⎇'
let g:airline_symbols.paste = 'ρ'
let g:airline_symbols.paste = 'Þ'
let g:airline_symbols.paste = '∥'
let g:airline_symbols.whitespace = 'Ξ'

" airline symbols
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:airline_symbols.branch = ''
let g:airline_symbols.readonly = ''
let g:airline_symbols.linenr = ''

" 여기에 LSP 관련 내용 추가
Plug 'neoclide/coc.nvim', {'branch': 'release'}
"Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
silent! source ~/.coc.vimrc
let g:coc_global_extensions = [
			\'coc-clangd',
			\'coc-pyright',
			\'coc-cmake',
			\'coc-git',
			\'coc-markdownlint',
			\'coc-terminal',
			\'coc-snippets',
			\'coc-calc',
			\'coc-json',
			\'coc-vimtex',
			\'coc-java',
			\'coc-kotlin',
			\'coc-pairs',
			\'coc-rust-analyzer',
			\'coc-go',
			\'coc-tsserver',
			\'coc-perl',
			\'coc-sql',
			\'coc-sh',
			\'coc-toml',
			\'coc-xml',
			\'coc-yaml',
			\]

"key mapping
let mapleader=","


" vim의 기본 f 기능을 확장함. 
" <leader><leader> s + <1char>: 현재 커서 기준으로 앞뒤에있는 <1char>로 점프
Plug 'Lokaltog/vim-easymotion'
let g:EasyMotion_do_mapping = 0

nmap <leader><leader>s <Plug>(easymotion-s)
xmap <leader><leader>s <Plug>(easymotion-s)
omap <leader><leader>s <Plug>(easymotion-s)

" Sneak 처럼 두 글자를 인식하여 너무 많은 패턴의 경우의 수를 제한한다.
nmap <leader><leader>S <Plug>(easymotion-s2)
xmap <leader><leader>S <Plug>(easymotion-s2)
omap <leader><leader>S <Plug>(easymotion-s2)

nmap f <Plug>(easymotion-s2)
xmap f <Plug>(easymotion-s2)
omap f <Plug>(easymotion-s2)

"tmux airline
Plug 'edkolev/tmuxline.vim'
let g:airline#extensions#tmuxline#enabled = 0

"Git graph
Plug 'rbong/vim-flog'


Plug 'Yggdroot/indentLine'
let g:indentLine_setConceal = 0 " Respect my conceal option!
let g:indentLine_char = '┊'
set list lcs=tab:\┊\ 

"fzf 설정
Plug 'junegunn/fzf', { 'do': './install --all' }
nnoremap <leader><C-n> :Files<CR>

if executable("rg")
	nnoremap <leader>r :Rg!<CR>
else
	nnoremap <leader>r :Ag!<CR>
endif

set rtp+=~/.vim/plugged/fzf
Plug 'junegunn/fzf.vim'

" ##### Folding #####

set foldmethod=syntax

" Support python folding
Plug 'tmhedberg/SimpylFold'

" Fold faster
Plug 'Konfekt/FastFold'

" Support highlighting for lots of languages
set re=0 " Disable old regex engine for performance
Plug 'sheerun/vim-polyglot'

" LaTeX
Plug 'lervag/vimtex'
let g:vimtex_fold_enabled=1
let g:vimtex_quickfix_open_on_warning=0
let g:vimtex_view_method='mupdf'

"vim tmux seamless navigation.
"Ctrl + hjkl to move pane/buffer
Plug 'christoomey/vim-tmux-navigator'

Plug 'voldikss/vim-floaterm'
let g:floaterm_keymap_toggle='<F1>'

Plug 'voldikss/fzf-floaterm'

Plug 'scrooloose/nerdtree'
nmap <C-n> :NERDTreeToggle <CR>

"nerdtree 자동 실행
"autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif

Plug 'coot/CRDispatcher'
Plug 'coot/EnchantedVim'
" Since I use incsearch:
set incsearch
let g:VeryMagic = 0
nnoremap / /\v
nnoremap ? ?\v
vnoremap / /\v
vnoremap ? ?\v
" If I type // or ??, I don't EVER want \v, since I'm repeating the previous
" search.
noremap // //
noremap ?? ??
" no-magic searching
noremap /v/ /\V
noremap ?V? ?\V

let g:VeryMagicSubstituteNormalise = 1
let g:VeryMagicSubstitute = 1
let g:VeryMagicGlobal = 1
let g:VeryMagicVimGrep = 1
let g:VeryMagicSearchArg = 1
let g:VeryMagicFunction = 1
let g:VeryMagicHelpgrep = 1
let g:VeryMagicRange = 1
let g:VeryMagicEscapeBackslashesInSearchArg = 1
let g:SortEditArgs = 1

call plug#end()			" required

"set theme
"set t_Co=256
"set t_ut= "테마 적용시 뒷 배경을 날리는 역할
"set bg=light
" Enable 24bit true color
if exists('+termguicolors')
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors
endif
set background=dark
silent! colorscheme gruvbox

syntax on
set nocompatible " 오리지날 VI와 호환하지 않음
set hlsearch
set lazyredraw
set ignorecase
set smartcase
set autoindent  " 자동 들여쓰기
set cindent " C 프로그래밍용 자동 들여쓰기
set smartindent " 스마트한 들여쓰기
set wrap " 문장이 한 줄로 넘어갈 경우 그 다음줄에 이어서 표시
set linebreak " wrap 사용시 단어 단위로 다음줄로 넘어가기
set nowrapscan " 검색할 때 문서의 끝에서 처음으로 안돌아감
set nobackup " 백업 파일을 안만듬
set noswapfile "스왑 파일을 만들지 않는다.
set visualbell " 키를 잘못눌렀을 때 화면 프레시
set belloff+=esc
set ruler " 화면 우측 하단에 현재 커서의 위치(줄,칸) 표시
set shiftwidth=4 " 자동 들여쓰기 4칸
set ts=4
set number " 행번호 표시, set nu 도 가능
set fencs=euc-kr,ucs-bom,utf-8
set conceallevel=2	" Basically prettify keywords if possible
set concealcursor=	" Disable syntax for current cursor line

"set cursorcolumn	" Visualize vertical cursor line
"set cursorline		" Visualize horizontal cursor line
"set tenc=utf-8	  " 터미널 인코딩

" In LaTeX mode, enable spellcheck
" If you want to register user-defined words, press zg on the word.
aug tex
	au FileType tex set spell spelllang=en_us
aug end

" Set filetype for custom extensions
autocmd! BufEnter *.shrc : set filetype=sh
autocmd! BufEnter *.shinit : set filetype=sh
autocmd! BufEnter *.nsp :set filetype=json

"https://vim.fandom.com/wiki/Make_buffer_modifiable_state_match_file_readonly_state
function UpdateModifiable()
	if !exists("b:setmodifiable")
		let b:setmodifiable = 0
	endif
	if &readonly
		if &modifiable
			setlocal nomodifiable
			let b:setmodifiable = 1
		endif
	else
		if b:setmodifiable
			setlocal modifiable
		endif
	endif
endfunction

autocmd BufReadPost * call UpdateModifiable()
if index(["dosbatch", "ps1"], &filetype) < 0
	"newline 형식이 dos (<CR><NL>)인경우 unix형식(<NL>)로 변경 후 저장
	autocmd BufReadPost * if &modifiable &&  &l:ff!="unix" | setlocal ff=unix | %s/\r//ge | write | endif
endif
"euc-kr로 입력이 들어온 경우, utf-8로 변환 후 저장.
autocmd BufReadPost * if &modifiable && &l:fenc=="euc-kr" | setlocal fenc=utf-8 | write | endif

" 마지막 편집 위치 복원 기능
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "norm g`\"" |
\ endif

"Vimdiff시 read only 무시
if &diff
	set noreadonly
endif

"파일이 변경될 때 마다 자동으로 버퍼 갱신
set autoread
au CursorHold * checktime

"vim의 검색 기능을 이용할 시 검색 결과를 항상 중앙에 배치한다.
nmap n nzz
nmap <S-n> <S-n>zz

"파이썬의 경우 탭 크기를 강제로 4칸으로 고정한다.
aug python
	au FileType python setlocal ts=4 sts=4 sw=4 noexpandtab
aug end

nnoremap <leader>q : bp!<CR> " 쉼표 + q : 이전 탭
nnoremap <leader>w : bn!<CR> " 쉼표 + w : 다음 탭
nnoremap <leader>d : bp <BAR> bd #<CR> " 쉼표 + d : 탭 닫기
nnoremap <leader>e <C-W>w " 쉼표 + w : 다음 창

function Run()
	let do_nothing_list = ["tex"]

	if &filetype == 'python'
		FloatermNew python3 "%:p"
	elseif &filetype == 'ocaml'
		FloatermNew ocaml "%:p"
	elseif &filetype == 'java'
		FloatermNew java "%:p"
	elseif &filetype == 'go'
		FloatermNew go run "%:p"
	elseif &filetype == 'erlang'
		FloatermNew escript "%:p" +P
	elseif &filetype == 'sh'
		FloatermNew bash "%:p"
	elseif &filetype == 'markdown'
		FloatermNew glow "%:p"
	elseif &filetype == 'typescript'
		let $TS_NODE_TRANSPILE_ONLY='true'
		FloatermNew ts-node "%:p"
	elseif &filetype == 'rust'
		FloatermNew cargo run || "%:p:r"
	elseif index(do_nothing_list, &filetype) >= 0
		" Do nothing
	elseif index(["c", "cpp"], &filetype) >= 0
		FloatermNew "%:p:r"
	else
		return 0
	endif

	return v:shell_error == 0
endfunction

function Compile()
	let do_nothing_list = ["markdown", "python", "sh", "erlang", "typescript", "java", "go", "ocaml"]

	write!
	if (filereadable('./Makefile') || filereadable('./makefile')) && &filetype != "markdown"
		silent make
	elseif &filetype == 'tex'
		VimtexCompile
	elseif &filetype=='c'
		silent !clang -std=c11 -W -Wall -g -O0 "%:p" -lpthread  -lm  -o "%:p:r"
	elseif &filetype == 'cpp'
		silent !clang++ -W -Wall -g -O0 "%:p" -lpthread -lm -o "%:p:r"
	elseif &filetype == 'rust'
		silent !cargo build || rustc "%:p"
	elseif index(do_nothing_list, &filetype) >= 0
		return 1
	else
		return 0
	endif


	redraw!
	return v:shell_error == 0
endfunction

function GotoBash() 
	!echo ""
	redraw!
endfunction

" Pipe selected visual block -- CHARACTER WISE -- to command.
" <C-u> after colon is used to cancel " '<,'> ", and it will be piped to
" command's stdin.
xnoremap <leader>c :<C-u> call PipeRangedSelection()<CR>

function! PipeRangedSelection()
	let cmd = input("Command: ")
	redraw
	echo system(cmd, GetVisualSelection(visualmode()))
endfunction

" Forked from https://stackoverflow.com/a/61486601
function! GetVisualSelection(mode)
	" call with visualmode() as the argument
	let [line_start, column_start] = getpos("'<")[1:2]
	let [line_end, column_end]     = getpos("'>")[1:2]
	let lines = getline(line_start, line_end)
	if a:mode ==# 'v'
		" Must trim the end before the start, the beginning will shift left.
		let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
		let lines[0] = lines[0][column_start - 1:]
	elseif  a:mode ==# 'V'
		" Line mode no need to trim start or end
	elseif  a:mode == "\<c-v>"
		" Block mode, trim every line
		let new_lines = []
		let i = 0
		for line in lines
			let lines[i] = line[column_start - 1: column_end - (&selection == 'inclusive' ? 1 : 2)]
			let i = i + 1
		endfor
	else
		return ''
	endif
	"for line in lines
	"    echom line
	"endfor
	return join(lines, "\n")
endfunction

function! Test()
	wa!

	if &filetype == 'typescript'
		FloatermNew npm t
	endif
endfunction

nmap <F9>       <Plug>(coc-codeaction-cursor)
nmap <ESC>[20~  <Plug>(coc-codeaction-cursor)

nmap <C-F5>      : if Compile() <bar> call Run() <bar> else <bar> call GotoBash() <bar> endif <CR>
nmap <ESC>[15;5~ : if Compile() <bar> call Run() <bar> else <bar> call GotoBash() <bar> endif <CR>
nmap <leader>t   : call Test() <CR>

" In some terminals (e.g. tmux), they cannot understand complex key bindings.
" So, in this case, we need to find out the complex binding is converted into
" several keys. 
" For example, if we want to know byte streams of Ctrl + F5, we
" just run xxd in bash, press <Ctrl + F5> and enter.
" Then, 1b5b 3135 3b35 7e0a will be printed. The last 0a is a return key, so
" remaining 7 bytes are what we wanted. The only left thing is, google ascii
" table and translate 7 bytes to '<esc>[15;5~'. 


function FindCursorPopUp()
	let radius = get(a:000, 0, 2)
	let srow = screenrow()
	let scol = screencol()
	" it's necessary to test entire rect, as some popup might be quite small
	for r in range(srow - radius, srow + radius)
		for c in range(scol - radius, scol + radius)
			let winid = popup_locate(r, c)
			if winid != 0
				return winid
			endif
		endfor
	endfor

	return 0
endfunction

function ScrollPopUp(down)
	let winid = FindCursorPopUp()
	if winid == 0
		return 0
	endif

	let pp = popup_getpos(winid)
	call popup_setoptions( winid,
				\ {'firstline' : pp.firstline + ( a:down ? 1 : -1 ) } )

	return 1
endfunction

if has('textprop') && has('patch-8.1.1610') 
	nnoremap <expr> <c-d> ScrollPopUp(1) ? '<esc>' : '<c-d>'
	nnoremap <expr> <c-u> ScrollPopUp(0) ? '<esc>' : '<c-u>'
endif

" FIX: ssh from wsl starting with REPLACE mode
" https://stackoverflow.com/a/11940894
if $TERM =~ 'xterm-256color'
	set noek
endif

highlight Comment cterm=italic gui=italic

highlight Statement cterm=italic gui=italic
highlight Conditional cterm=italic gui=italic
highlight Repeat cterm=italic gui=italic
highlight Label cterm=italic gui=italic
highlight Operator cterm=italic gui=italic
highlight Keyword cterm=italic gui=italic
highlight Exception cterm=italic gui=italic

highlight Type cterm=italic gui=italic
highlight StorageClass cterm=italic gui=italic
highlight Structure cterm=italic gui=italic
highlight Typedef cterm=italic gui=italic

