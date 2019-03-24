" ConqueTerm
map <leader>fp :ConqueTermTab bash<CR>

" auto source vimrc
autocmd! bufwritepost .vimrc source $HOME/.vimrc
