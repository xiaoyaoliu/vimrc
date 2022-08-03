
" removes trailing spaces of python files
" (and restores cursor position)
autocmd BufWritePre *.cpp mark z | %s/\s\+$//e | 'z
