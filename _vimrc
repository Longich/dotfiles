syntax on
set autoindent
set expandtab
set tabstop=4
set shiftwidth=4
set cursorline
set number

augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.rb setlocal tabstop=2 softtabstop=2 shiftwidth=2
augroup END

execute pathogen#infect()
