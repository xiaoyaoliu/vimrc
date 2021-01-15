map <leader>fe :silent !open -R %<CR>

" refesh ctags
:nnoremap <silent> ,66 :!ctags -f .tags -R > /dev/null 2>&1 &<CR>

highlight PMenu ctermfg=0 ctermbg=242 guifg=White guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=8 guifg=Yellow guibg=Black
