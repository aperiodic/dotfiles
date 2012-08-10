filetype off
" load pathogen from the bundle folder and initialize
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
filetype plugin indent on
syntax on


" Settings
" ========
" most of these are taken from Steve Losh's 'Coming Home to Vim' blog post:
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/

let mapleader = ","
let maplocalleader = ";"

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
set numberwidth=2
set undofile

set wrap
set textwidth=80
set linebreak
let &showbreak = '> '
set formatoptions=qrn1

set iskeyword=@,48-57,_,-,192-255

" make searching more sensible
nnoremap / /\v
vnoremap / /\v
set ignorecase
set smartcase
set gdefault
set incsearch
set showmatch
set hlsearch
nnoremap <leader><space> :noh<cr>


" Mappings
" ========

" move through screen lines, not file lines
nnoremap j gj
nnoremap k gk

nnoremap H 0
nnoremap L $

" vimrc editing & sourcing
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" easy buffer listing & movement
nnoremap <leader>l :ls<cr>
nnoremap <leader>n :bn<cr>
nnoremap <leader>p :bp<cr>

" vertical split
nnoremap <leader>v :vsp<cr>

" :x for buffers
cnoreabbrev bx up<bar>bd

" move lines up and down
nnoremap _ ddkP
nnoremap - ddp

" clear line
nnoremap <leader>d ddO<esc>

" replace newlines with spaces until next blank line
nnoremap <leader>f v/\v^$<cr>gk$h:s/\n/ /<cr>jO<esc>k:noh<cr>

" uppercase current word
inoremap <leader><c-u> <esc>viwUea


" Abbrevs
" =======
" they're sweeping the naish

iabbrev @@ dlp@aperiodic.org
iabbrev dlpwww http://aperiodic.org

au FocusLost * :wa

" sudo write
ca w!! w !sudo tee >/dev/null "%"

nnoremap Y y$
" instead of yy

set pastetoggle=<F2>


" clam config
" ===========
" open clam shell buffers in the lower half of the current pane
let g:clam_winpos = 'botright'

" ctrlp config
" ============
" i don't know what exactly wildignore does, but ctrlp sets it, and i don't
" care about these files anyways, so seems innocuous enough (famous last words)
set wildignore+=*.swp,*.swo,*.jar,*.class,.DS_Store
let g:ctrlp_custom_ignore = '\.git$'
" this refreshes the list of files in ctrlp (it's poorly named)
nnoremap <silent> <C-s> :ClearAllCtrlPCaches<cr>

" gundo config
" ============
nnoremap <F5> :GundoToggle<CR>

" slimv & paredit config
let g:slimv_leader = ';'
let g:slimv_repl_split = 3
let g:paredit_leader = ','

" swank config
" ============
" (may not be necessary, i don't care)
let g:swank_host = 'localhost'
let g:swank_port = '4005'


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

noh
