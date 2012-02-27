" Configuration file for vim
set modelines=0		" CVE-2007-2438
set ts=2
set sw=2
set number
set ai
set et
set ruler

"folding settings
set foldmethod=indent   "fold based on indent
set foldnestmax=10      "deepest fold is 10 levels
set nofoldenable        "dont fold by default
set foldlevel=1         "this is just what i use

call pathogen#runtime_append_all_bundles()

filetype plugin on
filetype indent on

syntax enable

" force .xml.template files to be treated as .xml files
au BufRead,BufNewFile *.xml.template set filetype=xml

" seriously man, i don't need spaces highlighted in red while i'm typing
let coffee_no_trailing_space_error = 1 
" instead i'll just remove trailing whitespace on save
autocmd BufWritePre * :%s/\s\+$//e

" Normally we use vim-extensions. If you want true vi-compatibility
" remove change the following statements
set nocompatible	" Use Vim defaults instead of 100% vi compatibility
set backspace=2		" more powerful backspacing

" Don't write backup file if vim is being called by "crontab -e"
au BufWrite /private/tmp/crontab.* set nowritebackup
" Don't write backup file if vim is being called by "chpass"
au BufWrite /private/etc/pw.* set nowritebackup

let processing_doc_path="/Applications/Processing.app/Contents/Resources/Java/reference/"

let mapleader = ","
:nnoremap <F7> :setl noai nocin nosi inde=<CR>
nmap S :w <C-m> :e # <C-m>
nmap E i <CR> <C-[>

" sudo write
ca w!! w !sudo tee >/dev/null "%"
