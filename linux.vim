
" https://zhuanlan.zhihu.com/p/33046090
" 不少人觉得 Vim 自动补全的弹出窗口默认配色很丑
" colors and settings of autocompletion
highlight PMenu ctermfg=0 ctermbg=242 guifg=White guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=8 guifg=Yellow guibg=Black

" auto source vimrc
autocmd! bufwritepost .vimrc source $HOME/.vimrc

" refesh ctags
:nnoremap <silent> ,66 :!ctags -f .tags -R > /dev/null 2>&1 &<CR>

" set fileencoding to default in windows
nmap <leader>cf :<C-U>setlocal nobomb<CR>:set fileencoding=utf-8<CR>:set ff=unix<CR>
