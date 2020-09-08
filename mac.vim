map <leader>fe :silent !open -R %<CR>

" refesh ctags
:nnoremap <silent> ,66 :!ctags -f .tags -R > /dev/null 2>&1 &<CR>

" 同时开启 ctags 和 gtags 支持, windows下只开启gtags(避免gutentags生成ctags的卡顿)：
let g:gutentags_modules = []
if executable('ctags')
	let g:gutentags_modules += ['ctags']
endif

