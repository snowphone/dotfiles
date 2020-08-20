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

Plug 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line


"256색 콘솔에서 gui용 테마 적용을 가능하게 함
Plug 'godlygeek/csapprox'

"테마(theme)
Plug 'nightsense/carbonized'
Plug 'tomasr/molokai'
Plug 'vim-scripts/gruvbox'
Plug 'float168/vim-colors-cherryblossom'

Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1			  " vim-airline 버퍼 목록 켜기
let g:airline#extensions#tabline#fnamemod = ':t'		  " vim-airline 버퍼 목록 파일명만 출력
let g:airline#extensions#tabline#buffer_nr_show = 1	   " buffer number를 보여준다
let g:airline#extensions#tabline#buffer_nr_format = '%s:' " buffer number format
set laststatus=2 " turn on bottom bar

let g:airline#extensions#whitespace#enabled = 0 		"Disable trailing whitespace warning
let g:airline_theme='fruit_punch'

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

Plug 'Townk/vim-autoclose'

" 여기에 LSP 관련 내용 추가
"Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'neoclide/coc.nvim', {'do': 'yarn install --frozen-lockfile'}
silent! source ~/.coc.vimrc


Plug 'luochen1990/rainbow'
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

"쉘의 프롬프트를 변경해주는 역할을 한다.
Plug 'snowphone/promptline.vim'

" vim의 기본 f 기능을 확장함. <leader><leader> w 혹은 <leader><leader> f를
" 써보길
Plug 'Lokaltog/vim-easymotion'

"tmux airline
Plug 'edkolev/tmuxline.vim'
let g:airline#extensions#tmuxline#enabled = 0

"Git graph
Plug 'rbong/vim-flog'


Plug 'Yggdroot/indentLine'
let g:indentLine_char = '┊'
set list lcs=tab:\┊\ 

"Highlighting for Typescript
Plug 'leafgarland/typescript-vim'
autocmd BufNewFile,BufRead *.ts setlocal filetype=typescript


"fzf 설정
Plug 'junegunn/fzf', { 'do': './install --all' }
nmap <C-n> :Files<CR>
nmap <leader>r :Rg!<CR>

set rtp+=~/.vim/plugged/fzf
Plug 'junegunn/fzf.vim'

" ##### Folding #####

" Support python folding
Plug 'tmhedberg/SimpylFold'

" Fold faster
Plug 'Konfekt/FastFold'
 
" LaTeX
Plug 'vim-latex/vim-latex'

set foldmethod=syntax
"autocmd FileType python,tex set foldmethod=manual 

"vim tmux seamless navigation.
"Ctrl + hjkl to move pane/buffer
Plug 'christoomey/vim-tmux-navigator'

call plug#end()			" required

"set theme
set t_Co=256
set t_ut= "테마 적용시 뒷 배경을 날리는 역할
set bg=dark
" Enable 24bit true color
if exists('+termguicolors')
	let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
	let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
	set termguicolors
endif
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
"set cursorcolumn	" Visualize vertical cursor line
"set cursorline		" Visualize horizontal cursor line
"set tenc=utf-8	  " 터미널 인코딩
"newline 형식이 dos (<CR><NL>)인경우 unix형식(<NL>)로 변경 후 저장
autocmd BufReadPost * if &l:ff!="unix" | setlocal ff=unix | %s/\r//ge | write | endif
"euc-kr로 입력이 들어온 경우, utf-8로 변환 후 저장.
autocmd BufReadPost * if &l:fenc=="euc-kr" | setlocal fenc=utf-8 | write | endif

" 마지막 편집 위치 복원 기능
au BufReadPost *
\ if line("'\"") > 0 && line("'\"") <= line("$") |
\   exe "norm g`\"" |
\ endif

"Vimdiff시 read only 무시
if &diff
	set noreadonly
endif

" Built-in terminal
"In terniaml, make it normal mode like vim.
tnoremap <F1> <C-W>N	
"Open built-in terminal in vim.
map <F1> :terminal<CR>		
"To paste into the terminal, <C-W>"<register> in insert mode.
"For example, typing <C-W>"" pastes data into the terminal.


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

" Very magic mode: vim regex follows normal rule, not vim customized rule
" For examle, normal vim identifies '(' as literal parenthesis but in regex it
" is evaluated as a capture group.
nnoremap / /\v
vnoremap / /\v
nnoremap ? ?\v
vnoremap ? ?\v
cnoremap s/ s/\v

"key mapping
let mapleader=","
nnoremap <leader>q : bp!<CR> " 쉼표 + q : 이전 탭
nnoremap <leader>w : bn!<CR> " 쉼표 + w : 다음 탭
nnoremap <leader>d : bp <BAR> bd #<CR> " 쉼표 + d : 탭 닫기
nnoremap <leader>e <C-W>w " 쉼표 + w : 다음 창

function Run()
	let do_nothing_list = ["tex"]

	if &filetype == 'python'
		:terminal python3 "%"
	elseif &filetype == 'java'
		terminal java %<
	elseif &filetype == 'erlang'
		terminal escript % +P
	elseif &filetype == 'sh'
		terminal bash %
	elseif &filetype == 'markdown'
		terminal bat %:p
	elseif &filetype == 'typescript'
		terminal ts-node "%"
	elseif &filetype == 'rust'
		terminal cargo run || ./%<
	elseif index(do_nothing_list, &filetype) >= 0
		" Do nothing
	elseif index(["c", "cpp"], &filetype) >= 0
		terminal ./%<
	else
		return -1
	endif

	return v:shell_error
endfunction

function Compile()
	let do_nothing_list = ["markdown", "python", "sh", "erlang", "typescript"]

	write!
	if filereadable('./Makefile') || filereadable('./makefile')
		silent make
	elseif &filetype == 'tex'
		:CocCommand latex.Build
	elseif &filetype=='c'
		 silent !clang -std=c11 -W -Wall -g -O0 % -lpthread  -lm  -o %<
	elseif &filetype == 'cpp'
		silent !clang++ -o %< -W -Wall -g -O0 % -lpthread -lm -lboost_system -lboost_program_options
	elseif &filetype == 'java'
		silent !javac %
	elseif &filetype == 'rust'
		silent !cargo build || rustc %
	elseif index(do_nothing_list, &filetype) >= 0
		"Do nothing
	else
		return -1
	endif


	redraw!
	return v:shell_error
endfunction

function GotoBash() 
	!echo ""
	redraw!
endfunction

" Pipe selected visual block to command after bang.
xnoremap <leader>c <esc>:'<,'>:w !

map <F5> : if Compile() == 0 <bar> call Run() <bar> else <bar> call GotoBash() <bar> endif <CR>


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

