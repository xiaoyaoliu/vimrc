language message zh_CN.UTF-8
map <leader>fp :term powershell<CR>

" https://zhuanlan.zhihu.com/p/33046090
" 不少人觉得 Vim 自动补全的弹出窗口默认配色很丑
" colors and settings of autocompletion
highlight PMenu ctermfg=0 ctermbg=242 guifg=black guibg=darkgrey
highlight PMenuSel ctermfg=242 ctermbg=8 guifg=darkgrey guibg=black

"highlight Pmenu ctermbg=4 guibg=LightGray
" highlight PmenuSel ctermbg=8 guibg=DarkBlue guifg=Red
" highlight PmenuSbar ctermbg=7 guibg=DarkGray
" highlight PmenuThumb guibg=Black



" auto source vimrc
autocmd! bufwritepost _vimrc source $HOME/_vimrc

let g:gutentags_modules = []

" refesh ctags
:nnoremap <silent> <leader>66 :!start ctags --output-format=e-ctags -f .tags -R .<CR>

nmap <leader>ww :<C-U><C-R>=printf("!start FileLocatorPro -d %s -f %s", shellescape(fnamemodify('.', ':p:h:h:p'), 1), expand("<cword>"))<CR><CR>

" set fileencoding to default in windows
nmap <leader>cf :<C-U>setlocal nobomb<CR>:set fileencoding=utf-8<CR>:set ff=dos<CR>

"open extern tool
map <leader>fe :silent !start explorer /select,%<CR>
map <leader>fgg :silent !start GitExtensions<CR>
map <leader>fgb :OpenBrowser google.com<CR>

"previm
" markdown预览快捷键的设置
nmap <silent> <leader>8 :PrevimOpen<CR>

" markdown-preview OBSOLETE
"nmap <silent> <leader>8 <Plug>MarkdownPreview<CR>

" vim-instant-markdown OBSOLETE
"let g:instant_markdown_autostart = 0
"nmap <silent> <leader>8 :InstantMarkdownPreview<CR>
"
"
