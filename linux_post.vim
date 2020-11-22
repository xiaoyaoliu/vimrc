
" vim在xshell等终端下的配色方案，推荐darkburn
" https://blog.csdn.net/linxxx3/article/details/6372755
colorscheme darkburn

" auto source vimrc
autocmd! bufwritepost .vimrc source $HOME/.vimrc

" refesh ctags
:nnoremap <silent> ,66 :!ctags -f .tags -R > /dev/null 2>&1 &<CR>

" set fileencoding to default in windows
nmap <leader>cf :<C-U>setlocal nobomb<CR>:set fileencoding=utf-8<CR>:set ff=unix<CR>
