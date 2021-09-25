filetype off
" load pathogen from the bundle folder and initialize
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()
filetype plugin indent on
syntax on

set path+=lib


" Settings
" ========
" most of these are taken from Steve Losh's 'Coming Home to Vim' blog post:
" http://stevelosh.com/blog/2010/09/coming-home-to-vim/

" make C-t esc
nnoremap <C-t> <Esc>
inoremap <C-t> <Esc>
vnoremap <C-t> <Esc>
cnoremap <C-t> <Esc>
onoremap <C-t> <Esc>

" disable space
nnoremap <space> <Esc>
vnoremap <space> <Esc>

let mapleader = ","
let maplocalleader = ";"

set timeoutlen=500

set nocompatible
set modelines=0

set tabstop=2
set shiftwidth=2
set softtabstop=2
set expandtab
set breakindent

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
set mouse=a

set wrap
set textwidth=80
set linebreak
let &showbreak = '  > '
set formatoptions=qrn1

set iskeyword=@,48-57,_,-,192-255

set background=dark
let g:solarized_termcolors=16
colorscheme solarized

set tags=./tags;

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

nnoremap <C-b> :b<space>

" vimrc editing & sourcing
nnoremap <leader>ev :vsplit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>

" easy buffer listing & movement
nnoremap <leader>l :ls<cr>
nnoremap <leader>n :bn<cr>
nnoremap <leader>p :bp<cr>

" splits
nnoremap <leader>v :vsp<cr>
nnoremap <leader>s :sp<cr>
nnoremap <leader>x <c-w>x

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

" count matches of last search pattern
nnoremap <leader>* :%s///gn<CR>


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

" Macros
" ======

" load files from file with a filename on each line
let @f='gf:b#j'


" Plugin Configuration
" ====================

" clam config
" ===========
" open clam shell buffers in the lower half of the current pane
let g:clam_winpos = 'botright'

" ctrlp config
" ============
" i don't know what exactly wildignore does, but ctrlp sets it, and i don't
" care about these files anyways, so seems innocuous enough (famous last words)
set wildignore+=*.swp,*.swo,*.jar,*.class,.DS_Store
let g:ctrlp_custom_ignore = '\v[\/](\.git|\.pytest_cache|env|py2-env)$'
" this refreshes the list of files in ctrlp (it's poorly named)
nnoremap <silent> <C-s> :ClearAllCtrlPCaches<cr>

" gundo config
" ============
nnoremap <F5> :GundoToggle<CR>
let g:gundo_prefer_python3 = 1

" jedi-vim config
" ===============
let g:jedi#environment_path = "env"
let g:jedi#goto_stubs_command = ""
let g:jedi#usages_command = ""
" jedi modifies completeopt to add 'longest', which I don't want
set completeopt=menuone,preview

" paredit config
" ==============
let g:paredit_leader = ','
let g:paredit_matchlines = 150

" vim-clojure-static config
" ==========================
let g:clojure_fuzzy_indent_patterns = ['^with', '^def', '^let', '^->', '^\.', '^try', '^fn', '^dom', '^are', '^GET', '^POST', '^PUT', '^HEAD', '^DELETE', '^fdef']

" syntastic
" =========
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 1
let g:syntastic_check_on_wq = 1

" airline
" =======
let g:airline_solarized_bg = 'dark'
let g:airline_powerline_fonts = 1

let g:airline_section_b = "\ue0a0 %{gitbranch#name()}"
let g:airline_section_y = ""

let g:airline_mode_map = {
    \ '__'     : '-',
    \ 'c'      : 'C',
    \ 'i'      : 'I',
    \ 'ic'     : 'I',
    \ 'ix'     : 'I',
    \ 'n'      : 'N',
    \ 'multi'  : 'M',
    \ 'ni'     : 'N',
    \ 'no'     : 'N',
    \ 'R'      : 'R',
    \ 'Rv'     : 'R',
    \ 's'      : 'S',
    \ 'S'      : 'S',
    \ 't'      : 'T',
    \ 'v'      : 'V',
    \ 'V'      : 'V',
    \ }


" Filetype-Specific Settings
" ==========================

" for markdown files, each line should be a sentence and each sentence a line,
" so i don't want the lines to wrap ever.
au FileType markdown set tw=99999

au FileType gitcommit set tw=72
au FileType cpp set tw=100 sw=4 ts=4 sts=4
au FileType python set tw=88 sw=4 ts=4 sts=4

" Random File Stuff
" ================

" remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" force .xml.template files to be treated as .xml files
au BufRead,BufNewFile *.xml.template set filetype=xml

" set groovy filetype for Jenkinsfiles
au BufNewFile,BufRead Jenkinsfile set ft=groovy

" set YAML filetype for Jinja-templated YAML
au BufNewFile,BufRead *.yaml.j2 set ft=yaml

" set YAML filetype for Salt state files
au BufNewFile,BufRead *.sls set ft=yaml

" enable arduino syntax highlighting for *.ino files
autocmd! BufNewFile,BufRead *.ino setlocal ft=arduino

" enable clojure stuff for hoplon files
autocmd! BufNewFile,BufRead *.hl setlocal ft=clojure

" set Dockerfile ft for any filename ending in 'Dockerfile'
autocmd! BufNewFile,BufRead *Dockerfile setlocal ft=Dockerfile

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup

" tabs and soft tabs are 4 spaces in c files
autocmd FileType c :setlocal sw=4 ts=4 sts=4

noh
