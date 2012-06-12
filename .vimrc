" Configuration file for vim
set modelines=0		" CVE-2007-2438
set ts=2
set sw=2
set number
set ai
set et
set ruler

" load pathogen from the bundle folder and initialize
runtime bundle/pathogen/autoload/pathogen.vim
call pathogen#infect()

filetype plugin on
filetype indent on
syntax on

" force .xml.template files to be treated as .xml files
au BufRead,BufNewFile *.xml.template set filetype=xml

" enable arduino syntax highlighting for *.ino files
autocmd! BufNewFile,BufRead *.ino setlocal ft=arduino

" remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup

let mapleader = ","

" sudo write
ca w!! w !sudo tee >/dev/null "%"

" instead of yy
map Y y$

set wildignore+=*/tmp/*,*.swp,*.swo,*.jar,*.class,.DS_Store
let g:ctrlp_custom_ignore = '\.git$'

" swank config (settings may not be necessary, i don't care)
let g:swank_host = 'localhost'
let g:swank_port = '4005'
let g:slimv_repl_split = 3

" open clam shell buffers in the lower half of the current pane
let g:clam_winpos = 'botright'
