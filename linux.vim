" ConqueTerm
map <leader>fp :ConqueTermTab bash<CR>

" auto source vimrc
autocmd! bufwritepost .vimrc source $HOME/.vimrc

" refesh ctags
:nnoremap <silent> ,6 :!ctags -R > /dev/null 2>&1 &<CR>
