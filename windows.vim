language message zh_CN.UTF-8
map <leader>fp :term powershell<CR>

" auto source vimrc
autocmd! bufwritepost _vimrc source $HOME/_vimrc

" refesh ctags
":nnoremap <silent> <leader>6 :!start ctags --output-format=e-ctags -f .tags -R .<CR>

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
set pythonthreehome=~/vimrc/bin/win32/python37
set pythonthreedll=~/vimrc/bin/win32/python37/python37.dll

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录. 
let g:gutentags_cache_dir = expand('~/.cache/tags')
