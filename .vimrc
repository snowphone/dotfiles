" Vundle 자동 설치용
" START - Setting up Vundle - the vim plugin bundler
let iCanHazVundle=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme)
	echo "Installing Vundle.."
	echo ""
	silent !mkdir -p ~/.vim/bundle
	silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
	let iCanHazVundle=0
endif
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#rc()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
if iCanHazVundle == 0
	echo "Installing Bundles, please ignore key map error messages"
	echo ""
	:PluginInstall
endif
" END - Setting up Vundle - the vim plugin bundler

filetype off				  " required
" set the runtime path to include Vundle and initialize
set rtp+=~/.vim/bundle/Vundle.vim




call vundle#begin('~/.vim/bundle/')
" alternatively, pass a path where Vundle should install plugins
"call vundle#begin('~/some/path/here')

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-fugitive'

" All of your Plugins must be added before the following line

Plugin 'scrooloose/nerdtree'

nmap <C-n> :NERDTreeToggle <CR>

"nerdtree 자동 실행
"autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | endif
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif


"256색 콘솔에서 gui용 테마 적용을 가능하게 함
Plugin 'godlygeek/csapprox'

"테마(theme)
Plugin 'nightsense/carbonized' "적용에 어려움이 있음
Plugin 'tomasr/molokai'
Plugin 'vim-scripts/gruvbox'
Plugin 'float168/vim-colors-cherryblossom'

Plugin 'vim-airline/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
let g:airline#extensions#tabline#enabled = 1			  " vim-airline 버퍼 목록 켜기
let g:airline#extensions#tabline#fnamemod = ':t'		  " vim-airline 버퍼 목록 파일명만 출력
let g:airline#extensions#tabline#buffer_nr_show = 1	   " buffer number를 보여준다
let g:airline#extensions#tabline#buffer_nr_format = '%s:' " buffer number format
set laststatus=2 " turn on bottom bar

let g:airline#extensions#whitespace#enabled = 0 		"Disable trailing whitespace warning
let g:airline_theme='bubblegum'

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

Plugin 'Townk/vim-autoclose'

Plugin 'Valloric/YouCompleteMe'
let g:ycm_global_ycm_extra_conf = '~/.vim/.ycm_extra_conf.py'

".ycm_global_ycm_extra_conf.py가 파일 타입을 얻어낼 수 있도록 함
let g:ycm_extra_conf_vim_data = [ '&filetype' ]

let g:ycm_use_clangd=1
let g:ycm_clangd_uses_ycmd_caching=0
let g:ycm_clangd_binary_path=exepath("clangd-8")
let g:ycm_clangd_args = ['-log=verbose', '-pretty']

"파이썬의 경우 탭 크기를 강제로 4칸으로 고정한다.
aug python
	" ftype/python.vim overwrites this
	au FileType python setlocal ts=4 sts=4 sw=4 noexpandtab
aug end


"bear <make command> 를 이용하여 태그 설정해야 goto 사용 가능
nmap <F12> :silent! YcmCompleter GoToDefinitionElseDeclaration <CR>

nmap <F9> :YcmCompleter FixIt<CR>

Plugin 'luochen1990/rainbow'
let g:rainbow_active = 1 "0 if you want to enable it later via :RainbowToggle

Plugin 'operator-user' 	"user defined key binding

Plugin 'uplus/vim-clang-rename'
au FileType c,cpp nmap <buffer><silent><leader>cr <Plug>(clang_rename-current)

"쉘의 프롬프트를 변경해주는 역할을 한다.
Plugin 'edkolev/promptline.vim'


"현재 커밋 키준으로 변경점을 왼쪽에 +, - ~으로 표시
Plugin 'airblade/vim-gitgutter'

" vim의 기본 f 기능을 확장함. <leader><leader> w 혹은 <leader><leader> f를
" 써보길
Plugin 'Lokaltog/vim-easymotion'

"들여쓰기마다 수직선 그어주는 역할
Plugin 'Yggdroot/indentLine'

"tmux airline
Plugin 'edkolev/tmuxline.vim'
let g:airline#extensions#tmuxline#enabled = 0

"Git graph
Plugin 'rbong/vim-flog'

"erlang
Plugin 'vim-erlang/vim-erlang-omnicomplete'

"vim tmux seamless navigation.
"Ctrl + hjkl to move pane/buffer
Plugin 'christoomey/vim-tmux-navigator'

call vundle#end()			" required

filetype plugin indent on	" required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList	   - lists configured plugins
" :PluginInstall	- installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean	  - confirms removal of unused plugins; append `!` to auto-approve removal
"
"set theme
set t_Co=256
set t_ut= "테마 적용시 뒷 배경을 날리는 역할
"set bg=light
silent! colo molokai

syntax on
set nocompatible " 오리지날 VI와 호환하지 않음
set hlsearch
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
set ruler " 화면 우측 하단에 현재 커서의 위치(줄,칸) 표시
set shiftwidth=4 " 자동 들여쓰기 4칸
set ts=4
set number " 행번호 표시, set nu 도 가능
set fencs=euc-kr,ucs-bom,utf-8
"set tenc=utf-8	  " 터미널 인코딩
"newline 형식이 dos (<CR><NL>)인경우 unix형식(<NL>)로 변경 후 저장
autocmd BufReadPost * if &l:ff!="unix" | setlocal ff=unix | %s/\r//ge | write | endif
"euc-kr로 입력이 들어온 경우, utf-8로 변환 후 저장.
autocmd BufReadPost * if &l:fenc=="euc-kr" | setlocal fenc=utf-8 | write | endif

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

"fzf 설정
set rtp+=~/.fzf


"key mapping
let mapleader=","
nnoremap <leader>q : bp!<CR> " 쉼표 + q : 이전 탭
nnoremap <leader>w : bn!<CR> " 쉼표 + w : 다음 탭
nnoremap <leader>d : bp <BAR> bd #<CR> " 쉼표 + d : 탭 닫기
nnoremap <leader>e <C-W>w " 쉼표 + w : 다음 창

func! BuildLaTex()
	!lualatex '%<'
	if !empty(glob("./*.bib"))
		!bibtex '%<'
		!lualatex '%<'
		!lualatex '%<'
	endif
endfunc

"tex 파일이면 lualatex로 컴파일, 아닌 경우면 cpp파일로 간주해서 컴파일
func! Run()
	if &filetype == 'python'
		:exec '!python3 "%"'
	elseif &filetype == 'java'
		!java %<
	elseif &filetype == 'erlang'
		!escript % +P
	elseif &filetype == 'sh'
		!bash %
	elseif &filetype == 'tex'
		!/mnt/c/Program\ Files/SumatraPDF/SumatraPDF.exe '%<.pdf' &
	else
		"c, c++
		!./%<
	endif
endfunc

func! Compile()
	write!

	if &filetype == 'tex'
		:exec BuildLaTex()
	elseif &filetype=='c'
		silent !clang % -std=c11 -O2 -W -Wall -g -lpthread -pthread -lm  -o %<
	elseif &filetype == 'python' || &filetype == 'sh' || &filetype == 'erlang'
		"echo means do nothing.
		echo ""
	elseif &filetype == 'java'
		!javac %
	else
		"c++
		silent !clang++ -o %< -W -Wall -O2 -pthread -lboost_system -lboost_program_options -lm %
		redraw!
	endif
endfunc

map <F5> :exec Compile()<CR> :exec Run()<CR>
"c++11로 컴파일 후 실행
map <F6> :w! <CR>  :!clang++ % -g -o %< -std=c++11 -O2<CR>  :! ./%< <CR>
map <F10> :w! <CR> :!g++ -g % -o %<  <CR> :!gdb %< <CR>
"euc-kr 인코딩을 utf-8로 변환 후 저장
map <F4> :e ++enc=euc-kr <CR> :set fenc=utf-8 <CR> :w ++enc=utf-8 <CR>
