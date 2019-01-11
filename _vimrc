syntax on
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set cursorline
set number

augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

execute pathogen#infect()

set nocompatible
filetype off

set rtp+=~/vimfiles/vundle.git/
call vundle#rc()
Bundle 'thinca/vim-ref'
filetype plugin indent on "required!
