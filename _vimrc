"""""""""""""""""""""""""""""""""""""""""
"""      My email : zhangxukim@gmail.com   "
"""""""""""""""""""""""""""""""""""""""""
set nocompatible
filetype off
"""""""""""""""""""""""""vundle setting""""""""""""""""""""
set rtp+=$HOME/.vim/bundle/Vundle.vim/
let path='$HOME/.vim/bundle'
call vundle#rc(path)

"""""""""""""""""""""""""install packages""""""""""""""""""
Bundle 'gmarik/vundle'
Bundle 'L9'
Bundle 'FuzzyFinder'

Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'majutsushi/tagbar'
Bundle 'kien/ctrlp.vim'
Bundle 'fisadev/vim-ctrlp-cmdpalette'
Bundle 'Valloric/YouCompleteMe'
Bundle 'godlygeek/tabular'
Bundle 'plasticboy/vim-markdown'
Bundle 'mattn/emmet-vim'
Bundle 'motemen/git-vim'
Bundle 'kien/tabman.vim'
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'mileszs/ack.vim'
Bundle 'lsdr/monokai'
Bundle 'rosenfeld/conque-term'
Bundle 'fisadev/FixedTaskList.vim'
Bundle 'tpope/vim-surround'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'honza/vim-snippets'
Bundle 'garbas/vim-snipmate'
Bundle 'airblade/vim-gitgutter'
"Bundle 'vim-scripts/indentpython.vim--nianyang'
Bundle 'nvie/vim-flake8'
"Bundle 'fs111/pydoc.vim'
Bundle 'AutoComplPop'
Bundle 'vim-syntastic/syntastic'
Bundle 'IndexedSearch'
"Bundle 'matchit.zip'
"Bundle 'Wombat'
"Bundle 'YankRing.vim'
"Bundle 'xptemplate'
Bundle 'chriskempson/base16-vim'
Bundle 'rainbow_parentheses.vim'
Bundle 'Yggdroot/indentLine'

"""""""""""""""""""""""""basic setting"""""""""""""""""""""
filetype plugin indent on
let g:python_recommended_style = 0

syntax on
set bsdir=buffer
set autochdir
set enc=utf-8
set encoding=utf-8
set fencs=utf-8,ucs-bom,shift-jis,gb18030,gbk,gb2312,cp936
set langmenu=zh_CN.UTF-8
language message zh_CN.UTF-8
set helplang=cn
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
"source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin
set nocompatible
set nobackup
set ignorecase 
set incsearch
set gdefault
set nu!
set ruler
set autoindent
set noexpandtab
"set noautoindent
"set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
"set shiftwidth=4
set clipboard+=unnamed
autocmd! bufwritepost _vimrc source $HOME/_vimrc
colorscheme monokai
"set guifont=Courier_New:h12:cANSI
"set guifontwide=YaHei\ Consolas\ Hybrid:h12
"set guifont=YaHei\ Consolas\ Hybrid:h12
"set guifont=Source\ Code\ Pro\ Semibold:h12
set guifont=Ubuntu\ Mono:h12
set scrolloff=3
set wildmode=list:longest
set ls=2

""""""""""""""""""""""""""""""""""""package settings"""""""""""""""

"run python
nnoremap <silent> ,5 :!python %<CR>
nnoremap <silent> ,6 :!py -3 %<CR>

" toggle Tagbar display
nmap ,4 :TagbarToggle<CR>
" autofocus on Tagbar open
let g:tagbar_autofocus = 1

" NERDTree (better file browser) toggle
nmap ,3 :NERDTreeToggle<CR>

" show pending tasks list
map ,2 :TaskList<CR>

" tab navigation
map tn :tabn<CR>
map tp :tabp<CR>
map tm :tabmove
map tt :tabnew 
map ts :tab split<CR>
map <C-S-Right> :tabn<CR>
imap <C-S-Right> <ESC>:tabn<CR>
map <C-S-Left> :tabp<CR>
imap <C-S-Left> <ESC>:tabp<CR>

" navigate windows with meta+arrows
map <M-Right> <c-w>l
map <M-Left> <c-w>h
map <M-Up> <c-w>k
map <M-Down> <c-w>j
imap <M-Right> <ESC><c-w>l
imap <M-Left> <ESC><c-w>h
imap <M-Up> <ESC><c-w>k
imap <M-Down> <ESC><c-w>j

" fix some problems with gitgutter and jedi-vim
let g:gitgutter_eager = 0
let g:gitgutter_realtime = 0

" automatically close autocompletion window
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" old autocomplete keyboard shortcut
imap <C-J> <C-X><C-O>


" removes trailing spaces of python files
" (and restores cursor position)
autocmd BufWritePre *.py mark z | %s/\s\+$//e | 'z

" store yankring history file hidden
let g:yankring_history_file = '.yankring_history'

" save as sudo
ca w!! w !sudo tee "%"

" colors and settings of autocompletion
highlight Pmenu ctermbg=4 guibg=LightGray
" highlight PmenuSel ctermbg=8 guibg=DarkBlue guifg=Red
" highlight PmenuSbar ctermbg=7 guibg=DarkGray
" highlight PmenuThumb guibg=Black

" insert ipdb breakpoint with \b
nmap <leader>b Oimport ipdb;ipdb.set_trace()<ESC>

" ack.vim -i(ignore-case), -w(whole-word), -v(invert-match)
nmap ,rr :Ack! -i 
nmap ,rw :Ack! -w <cword> .
nmap ,rss :Ack! --ignore-dir=cdata,data,cdata_beta -i 
nmap ,rsw :Ack! --ignore-dir=cdata,data,cdata_beta -w <cword> ..
nmap ,rll :AckWindow! 
nmap ,rlw :AckWindow! -w <cword><CR>
nmap ,ra :AckAdd -i 
nmap ,rf :AckFile -i 
nmap ,rp :Ack! --python -i 
nmap ,wr :Ack! -w <cword><CR>

" CtrlP (new fuzzy finder)
let g:ctrlp_map = ',e'
nmap ,fG :CtrlPBufTag<CR>
nmap ,fg :CtrlPBufTagAll<CR>
nmap ,ff :CtrlPLine<CR>
nmap ,fm :CtrlPMRUFiles<CR>
nmap ,fc :CtrlPCmdPalette<CR>
" to be able to call CtrlP with default search text
function! CtrlPWithSearchText(search_text, ctrlp_command_end)
    execute ':CtrlP' . a:ctrlp_command_end
    call feedkeys(a:search_text)
endfunction
" CtrlP with default text
nmap ,wG :call CtrlPWithSearchText(expand('<cword>'), 'BufTag')<CR>
nmap ,wg :call CtrlPWithSearchText(expand('<cword>'), 'BufTagAll')<CR>
nmap ,wf :call CtrlPWithSearchText(expand('<cword>'), 'Line')<CR>
nmap ,we :call CtrlPWithSearchText(expand('<cword>'), '')<CR>
nmap ,pe :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>
nmap ,wm :call CtrlPWithSearchText(expand('<cword>'), 'MRUFiles')<CR>
nmap ,wc :call CtrlPWithSearchText(expand('<cword>'), 'CmdPalette')<CR>
" 善于使用help命令查看官方解释，例如:help ctrlp_working_path_mode  
" 默认进入文件模式，可以使用<C-d>切换
let g:ctrlp_by_filename = 1
" 延迟搜索，提升搜索时的输入体验
let g:ctrlp_lazy_update = 1
" 给更多的文件建索引，避免有些文件搜不到
let g:ctrlp_max_files = 20000
" 将返回的搜索结果提升为20，改善搜到却不显示的情况
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:20,results:20'
" Ignore files on fuzzy finder
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|res|tools|doc)$',
  \ 'file': '\v\.(pyc|pyo|exe|so|dll|lnk|swp|tmp)$',
  \ }

" Ignore files on NERDTree
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\.lnk$']

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

"syntastic Recommended settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 1

" YouCompleteMe customizations
nmap ,d :YcmCompleter GoTo<CR>
nmap K :YcmCompleter GetDoc<CR>
nmap ,o :YcmCompleter GoToReferences<CR>
nmap ,D :tab split<CR>,d
let g:ycm_key_invoke_completion = '<C-m>'

"let g:jedi#rename_command = "<leader>r"
"let g:jedi#show_call_signatures = "0"

" Change snipmate binding, to avoid problems with jedi-vim
imap <C-i> <Plug>snipMateNextOrTrigger

" tabman shortcuts
let g:tabman_toggle = 'tl'
let g:tabman_focus  = 'tf'

" vim-airline-themes settings
let g:airline_powerline_fonts = 0
let g:airline_theme = 'light'
let g:airline#extensions#whitespace#enabled = 1

" ConqueTerm
map ,ps :ConqueTermTab powershell.exe<CR>

" markdown
let g:vim_markdown_folding_disabled=1

" Better Rainbow Parentheses
let g:rbpt_colorpairs = [
    \ ['brown',       'RoyalBlue3'],
    \ ['Darkblue',    'SeaGreen3'],
    \ ['darkgray',    'DarkOrchid3'],
    \ ['darkgreen',   'firebrick3'],
    \ ['darkcyan',    'RoyalBlue3'],
    \ ['darkred',     'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['brown',       'firebrick3'],
    \ ['gray',        'RoyalBlue3'],
    \ ['black',       'SeaGreen3'],
    \ ['darkmagenta', 'DarkOrchid3'],
    \ ['Darkblue',    'firebrick3'],
    \ ['darkgreen',   'RoyalBlue3'],
    \ ['darkcyan',    'SeaGreen3'],
    \ ['darkred',     'DarkOrchid3'],
    \ ['red',         'firebrick3'],
    \ ]
let g:rbpt_max = 16
let g:rbpt_loadcmd_toggle = 0
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" IndentLine
let g:indentLine_color_gui = '#A4E57E'
