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

filetype off                  " required
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

"nerdtree 자동 실행
"autocmd vimenter * NERDTree
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif
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
let g:airline#extensions#tabline#enabled = 1              " vim-airline 버퍼 목록 켜기
let g:airline#extensions#tabline#fnamemod = ':t'          " vim-airline 버퍼 목록 파일명만 출력
let g:airline#extensions#tabline#buffer_nr_show = 1       " buffer number를 보여준다
let g:airline#extensions#tabline#buffer_nr_format = '%s:' " buffer number format

set laststatus=2 " turn on bottom bar

Plugin 'rip-rip/clang_complete'
"헤더 파일과 연동
let g:clang_library_path='/usr/lib/llvm-6.0/lib/libclang-6.0.so.1'
"let g:clang_library_path='/usr/lib/llvm-3.8/lib/libclang-3.8.so.1'
let g:clang_user_options='-std=c++17'
"boost 등 사용했을 때 자동 완성 속도 향상 시키기 위함
let g:clang_use_library=1
set include=^\\s*#\\s*include\ \\(<boost/\\)\\@!


Plugin 'ervandew/supertab'

autocmd FileType tex
            \ if &omnifunc != '' |
            \   call SuperTabChain(&omnifunc, "<c-n>") |
            \   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
            \ endif

autocmd FileType python
            \ if &omnifunc != '' |
            \   call SuperTabChain(&omnifunc, "<C-Space>") |
            \   call SuperTabSetDefaultCompletionType("<c-x><c-u>") |
            \ endif

inoremap <expr> <C-n> pumvisible() ? '<C-n>' :
            \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <M-,> pumvisible() ? '<C-n>' :
            \ '<C-x><C-o><C-n><C-p><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'

inoremap <expr> <tab> pumvisible() ? '<tab>' :
            \ '<C-n><C-r>=pumvisible() ? "\<lt>Down>" : ""<CR>'



Plugin 'Townk/vim-autoclose'

"Plugin 'davidhalter/jedi-vim' "python ide

Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

"Plugin 'w0rp/ale' "clangd가 실행되지 않는 문제가 있어 vim-lsp로 대체

Plugin 'prabirshrestha/async.vim' 
Plugin 'prabirshrestha/vim-lsp'
"goto definition, rename 및 컴파일 에러 체크 가능. 
"추가로 autocompletion 및 auto-formatter 등이 가능하나, autocompletion은 아직
"사용법을 찾지 못했고, formatter는 서버 통신과정에서 텍스트가 손실되는 것
"같다.

let g:lsp_signs_enabled = 1         " 좌측에 어느 부분이 오류인지 표기하는 기능
let g:lsp_signs_error = {'text': '>'}
let g:lsp_signs_warning = {'text': '-'}
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in normal mode, airlines에 에러 띄워주는 역할

if executable('clangd')
	    au User lsp_setup call lsp#register_server({
		        \ 'name': 'clangd',
		        \ 'cmd': {server_info->['clangd']},
		        \ 'whitelist': ['c', 'cpp', 'objc', 'objcpp'],
		        \ })
	endif

nmap <F12> :LspDefinition <CR>
nmap <F2> :LspRename <CR>

Plugin 'rhysd/vim-clang-format'	"clang-format을 이용한 c family formatter. 사실상 vim용 wrapper
let g:clang_format#style_options = {
            \ 'AccessModifierOffset' : -4,
			\}



call vundle#end()            " required

filetype plugin indent on    " required
" To ignore plugin indent changes, instead use:
"filetype plugin on
"
" Brief help
" :PluginList       - lists configured plugins
" :PluginInstall    - installs plugins; append `!` to update or just :PluginUpdate
" :PluginSearch foo - searches for foo; append `!` to refresh local cache
" :PluginClean      - confirms removal of unused plugins; append `!` to auto-approve removal
"
"set theme
set t_Co=256
set t_ut= "테마 적용시 뒷 배경을 날리는 역할
"set bg=light
colo carbonized-light

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
"set tenc=utf-8      " 터미널 인코딩
"newline 형식이 dos (<CR><NL>)인경우 unix형식(<NL>)로 변경 후 저장
autocmd BufReadPost * if &l:ff!="unix" | setlocal ff=unix | %s/\r//ge | write | endif
"euc-kr로 입력이 들어온 경우, utf-8로 변환 후 저장.
autocmd BufReadPost * if &l:fenc=="euc-kr" | setlocal fenc=utf-8 | write | endif

"key mapping
nmap <C-n> :NERDTreeToggle <CR>

let mapleader=","
nnoremap <leader>q : bp!<CR> " 쉼표 + q : 이전 탭
nnoremap <leader>w : bn!<CR> " 쉼표 + w : 다음 탭
nnoremap <leader>d : bp <BAR> bd #<CR> " 쉼표 + d : 탭 닫기
nnoremap <leader>e <C-W>w " 쉼표 + w : 다음 창

"tex 파일이면 pdflatex로 컴파일, 아닌 경우면 cpp파일로 간주해서 컴파일
func! Run()
	if &filetype == 'python'
		:exec '!python3 "%"'
	elseif &filetype == 'erlang'
		!escript % +P
	elseif &filetype != 'tex'
		!./%< 
	endif
endfunc

func! Compile()
	:write! 
	if &filetype == 'tex'
		!pdflatex -shell-escape %
	elseif &filetype=='c'
		silent !clang % -std=c99 -W -Wall -g -lpthread -pthread -lm  -o %< 
	elseif &filetype == 'erlang'
		"echo means do nothing.
		:echo ""
	elseif &filetype == 'python'
		"echo means do nothing.
		:echo ""
	else
		silent !g++ -W -Wall -O2 % -o %< 
	endif
endfunc

map <C-S-B> : exec Compile() <CR>
map <F5> :exec Compile()<CR> :exec Run()<CR>
"c++11로 컴파일 후 실행
map <F6> :w! <CR>  :!clang++ % -g -o %< -std=c++11 -O2<CR>  :! ./%< <CR>
map <F7> :w! <CR>  :!pdflatex % <CR>
map <F10> :w! <CR> :!g++ -g % -o %<  <CR> :!gdb %< <CR>
"euc-kr 인코딩을 utf-8로 변환 후 저장
map <F4> :e ++enc=euc-kr <CR> :set fenc=utf-8 <CR> :w ++enc=utf-8 <CR>
