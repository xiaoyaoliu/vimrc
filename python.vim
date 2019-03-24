Bundle 'fs111/pydoc.vim'
Bundle 'fisadev/vim-isort'
Bundle 'vim-scripts/indentpython.vim'

" removes trailing spaces of python files
" (and restores cursor position)
autocmd BufWritePre *.py mark z | %s/\s\+$//e | 'z

" syntastic
let g:syntastic_python_checkers = ['flake8']

let g:python_recommended_style = 0
