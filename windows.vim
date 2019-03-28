language message zh_CN.UTF-8
" ConqueTerm
map <leader>fp :silent ConqueTermTab powershell.exe<CR>

" auto source vimrc
autocmd! bufwritepost _vimrc source $HOME/_vimrc

" refesh ctags
:nnoremap <silent> <leader>6 :!start ctags -R .<CR>
