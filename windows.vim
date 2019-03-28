language message zh_CN.UTF-8
" ConqueTerm
map <leader>fp :silent ConqueTermTab powershell.exe<CR>

" auto source vimrc
autocmd! bufwritepost _vimrc source $HOME/_vimrc

" refesh ctags
:nnoremap <silent> <leader>6 :!start ctags -R .<CR>

nmap <leader>ww :<C-U><C-R>=printf("!start FileLocatorPro -d %s -f %s", shellescape(fnamemodify('.', ':p:h:h:p'), 1), expand("<cword>"))<CR><CR>
