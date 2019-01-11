syntax on
set autoindent
set expandtab
set tabstop=2
set shiftwidth=2
set cursorline
set number

augroup fileTypeIndent
  autocmd!
  autocmd BufNewFile,BufRead *.java setlocal tabstop=4 softtabstop=4 shiftwidth=4
augroup END

