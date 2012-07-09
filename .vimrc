filetype off
" load pathogen from the bundle folder and initialize
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
filetype plugin indent on

" most of these are taken from Steve Losh's 'Coming Home to Vim' blog post:
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/
set nocompatible
set modelines=0

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab

set encoding=utf-8
set scrolloff=5
set autoindent
set showmode
set showcmd
set hidden
set wildmenu
set wildmode=list:longest
set visualbell
set ttyfast
set ruler
set backspace=indent,eol,start
set laststatus=2 " always
set relativenumber
set undofile

syntax on

let mapleader = ","

nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>
nnoremap <tab> %
vnoremap <tab> %

set wrap
set textwidth=80
set formatoptions=qrn1

nnoremap j gj
nnoremap k gk

au FocusLost * :wa

" sudo write
ca w!! w !sudo tee >/dev/null "%"

map Y y$
" instead of yy

set pastetoggle=<F2>


" ctrlp config
" ============
" i don't know what exactly wildignore does, but ctrlp sets it, and i don't
" care about these files anyways, so seems innocuous enough (famous last words)
set wildignore+=*.swp,*.swo,*.jar,*.class,.DS_Store
let g:ctrlp_custom_ignore = '\.git$'
" this refreshes the list of files in ctrlp (it's poorly named)
nnoremap <silent> <C-s> :ClearAllCtrlPCaches<cr>

" swank config
" ============
" (may not be necessary, i don't care)
let g:swank_host = 'localhost'
let g:swank_port = '4005'
let g:slimv_repl_split = 3

" clam config
" ===========
" open clam shell buffers in the lower half of the current pane
let g:clam_winpos = 'botright'


" Random File Stuff
" ================

" remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" force .xml.template files to be treated as .xml files
au BufRead,BufNewFile *.xml.template set filetype=xml

" enable arduino syntax highlighting for *.ino files
autocmd! BufNewFile,BufRead *.ino setlocal ft=arduino

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup
