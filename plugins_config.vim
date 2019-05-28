"""""""""""""""""""""""""vundle setting""""""""""""""""""""
set nocompatible  " 去除VI一致性,vundle必须
filetype off                  " 必须

" 设置包括vundle和初始化相关的runtime path
set rtp+=$HOME/.vim/bundle/Vundle.vim/
let path='$HOME/.vim/bundle'
call vundle#rc(path)

"""""""""""""""""""""""""install packages""""""""""""""""""
" avoid bundle is clean up by BundleClean, 让vundle管理插件版本,必须
Bundle 'VundleVim/Vundle.vim'
Bundle 'gmarik/vundle'
Bundle 'L9'
Bundle 'FuzzyFinder'
Bundle 'scrooloose/nerdtree'
Bundle 'scrooloose/nerdcommenter'
Bundle 'majutsushi/tagbar'
Bundle 'kien/ctrlp.vim'
Bundle 'fisadev/vim-ctrlp-cmdpalette'
if has('python') || has('python3')
    Bundle 'Yggdroot/LeaderF'
else
    Bundle 'mileszs/ack.vim'
    Bundle 'rking/ag.vim'
endif
Bundle 'Valloric/YouCompleteMe'
Bundle 'ludovicchabant/vim-gutentags'
Bundle 'godlygeek/tabular'
Bundle 'plasticboy/vim-markdown'
Bundle 'MattesGroeger/vim-bookmarks'
Bundle 'mattn/emmet-vim'
Bundle 'mhinz/vim-signify'
Bundle 'motemen/git-vim'
Bundle 'kien/tabman.vim'
Bundle 'vim-airline/vim-airline'
Bundle 'vim-airline/vim-airline-themes'
Bundle 'rosenfeld/conque-term'
Bundle 'fisadev/FixedTaskList.vim'
Bundle 'tpope/vim-surround'
Bundle 'michaeljsmith/vim-indent-object'
Bundle 'MarcWeber/vim-addon-mw-utils'
Bundle 'tomtom/tlib_vim'
Bundle 'honza/vim-snippets'
Bundle 'garbas/vim-snipmate'
Bundle 'tpope/vim-fugitive'
Bundle 'juneedahamed/svnj.vim'
Bundle 'nvie/vim-flake8'
Bundle 'vim-syntastic/syntastic'
Bundle 'IndexedSearch'
Bundle 'matchit.zip'
Bundle 'vim-scripts/YankRing.vim'
Bundle 'vim-scripts/xptemplate'
"Bundle 'vim-scripts/AutoComplPop'
"Bundle 'vim-scripts/Wombat'
Bundle 'chriskempson/base16-vim'
Bundle 'rainbow_parentheses.vim'
Bundle 'Yggdroot/indentLine'
Bundle 'xiaoyaoliu/vim-rooter'

if has("win16") || has("win32")
    Bundle 'lsdr/monokai'
    Bundle 'previm/previm'
    Bundle 'tyru/open-browser.vim'
    Bundle 'haya14busa/vim-open-googletranslate'
endif
" python plugins
"Bundle 'fs111/pydoc.vim'

" 你的所有插件需要在下面这行之前
call vundle#end()            " 必须
" Enable filetype plugins
filetype plugin indent on    " 必须 加载vim自带和插件相应的语法和文件类型相关脚本

" toggle Tagbar display
nmap <leader>4 :TagbarToggle<CR>
" autofocus on Tagbar open
let g:tagbar_autofocus = 1

" NERDTree (better file browser) toggle
nmap <leader>3 :NERDTreeToggle<CR>

" show pending tasks list
map <leader>2 :TaskList<CR>

" Begin markdown
" 暂不适应markdown的折叠功能，在这里关掉
let g:vim_markdown_folding_disabled=1
" END markdown 

" fix some problems with gitgutter and jedi-vim
let g:gitgutter_eager = 0
let g:gitgutter_realtime = 0

" automatically close autocompletion window
autocmd CursorMovedI * if pumvisible() == 0|pclose|endif
autocmd InsertLeave * if pumvisible() == 0|pclose|endif

" old autocomplete keyboard shortcut
imap <C-J> <C-X><C-O>


" store yankring history file hidden
let g:yankring_history_file = '.yankring_history'

" colors and settings of autocompletion
highlight Pmenu ctermbg=4 guibg=LightGray
" highlight PmenuSel ctermbg=8 guibg=DarkBlue guifg=Red
" highlight PmenuSbar ctermbg=7 guibg=DarkGray
" highlight PmenuThumb guibg=Black

if has('python') || has('python3')
    " rg https://github.com/BurntSushi/ripgrep
    nmap <leader>ra :Leaderf! rg -g !tags --append -e 
    nmap <leader>rb :Leaderf! rg -F --all-buffers -e 
    nmap <leader>rB :Leaderf! rg -F --current-buffer -e 
    nmap <leader>rd :LeaderfTagPattern 
    nmap <leader>ri :Leaderf! rg -g !tags -i -e 
    nmap <leader>rm :LeaderfMru<CR>
    nmap <leader>rs :Leaderf! rg -F --stayOpen -e 
    nmap <leader>ro :<C-U>Leaderf! rg --recall<CR>
    nmap <Leader>rp :Leaderf! rg -g *.h -t py -e 
    nmap <leader>rr :Leaderf! rg -g !tags -e 
    nmap <leader>rw :Leaderf! rg -g !tags -w -e 
    " search word under cursor, the pattern is treated as regex, and enter normal mode directly
    nmap <leader>wr :<C-U><C-R>=printf("Leaderf! rg -g !tags -e %s", expand("<cword>"))<CR>

    nmap <leader>wf :LeaderfFileCword<CR>

    nmap <leader>wd :LeaderfTagCword<CR>

    nmap <leader>wt :LeaderfBufTagAllCword<CR>
    nmap <leader>wT :LeaderfBufTagCword<CR>

    nmap <leader>wm :LeaderfMruCword<CR>

    nmap <leader>wb :<C-U><C-R>=printf("Leaderf! rg -F --all-buffer -e %s", expand("<cword>"))<CR>
    nmap <leader>wB :LeaderfLineCword<CR>
else
    " ack.vim -i(ignore-case), -w(whole-word), -v(invert-match)
    " https://github.com/ggreer/the_silver_searcher
    let g:ackprg = 'ag --vimgrep --smart-case'
    nmap <leader>rr :Ack! --ignore=tags 
    nmap <leader>rw :Ack! --ignore=tags -w 
    nmap <leader>rss :Ack! --ignore=tags,cdata,data,cdata_beta -i 
    nmap <leader>rsw :Ack! --ignore=tags,cdata,data,cdata_beta -w <cword> ..
    nmap <leader>rll :AckWindow! 
    nmap <leader>rlw :AckWindow! -w <cword><CR>
    nmap <leader>ra :AckAdd -i 
    nmap <leader>rf :AckFile -i 
    nmap <leader>wr :<C-U><C-R>=printf("Ack! --ignore=tags %s", expand("<cword>"))<CR>
endif
vnoremap <silent> rr :call VisualSelection('gv', '')<CR>

" CtrlP (new fuzzy finder)
let g:ctrlp_map = '<leader>e'
nmap <leader>eG :CtrlPBufTag<CR>
nmap <leader>eg :CtrlPBufTagAll<CR>
nmap <leader>ef :CtrlPLine<CR>
nmap <leader>em :CtrlPMRUFiles<CR>
nmap <leader>ec :CtrlPCmdPalette<CR>
" to be able to call CtrlP with default search text
function! CtrlPWithSearchText(search_text, ctrlp_command_end)
    execute ':CtrlP' . a:ctrlp_command_end
    call feedkeys(a:search_text)
endfunction
" CtrlP with default text
nmap <leader>pe :call CtrlPWithSearchText(expand('<cfile>'), '')<CR>
nmap <leader>wh :call CtrlPWithSearchText(expand('<cword>'), 'CmdPalette')<CR>
" 善于使用help命令查看官方解释，例如:help ctrlp_working_path_mode  
let g:ctrlp_clear_cache_on_exit = 0
" 默认进入文件模式，可以使用<C-d>切换
let g:ctrlp_by_filename = 1
" 延迟搜索，提升搜索时的输入体验
let g:ctrlp_lazy_update = 1
" 给更多的文件建索引，避免有些文件搜不到
let g:ctrlp_max_files = 20000
" 将返回的搜索结果提升为50，改善搜到却不显示的情况
let g:ctrlp_match_window = 'bottom,order:btt,min:1,max:50,results:50'
" Ignore files on fuzzy finder
let g:ctrlp_custom_ignore = {
  \ 'dir':  '\v[\/](\.git|\.hg|\.svn|res|tools|doc)$',
  \ 'file': '\v\.(pyc|pyo|exe|so|dll|lnk|swp|tmp)$',
  \ }

" Ignore files on NERDTree
let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\.lnk$']

"syntastic Recommended settings
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_check_on_open = 0
let g:syntastic_check_on_wq = 0


" YouCompleteMe customizations
nmap <leader>k :YcmCompleter GetDoc<CR>
nmap <leader>o :YcmCompleter GoToReferences<CR>
nmap <leader>D :tab split<CR><C-]>
let g:ycm_key_invoke_completion = '<C-m>'
let g:ycm_seed_identifiers_with_syntax = 0
let g:ycm_show_diagnostics_ui = 0
let g:ycm_collect_identifiers_from_tags_files = 1
let g:ycm_min_num_identifier_candidate_chars = 1
let g:ycm_collect_identifiers_from_comments_and_strings = 1
let g:ycm_filetype_whitelist = { 
			\ "c":1,
			\ "cpp":1, 
			\ "objc":1,
			\ "sh":1,
			\ "zsh":1,
			\ "zimbu":1,
			\ "py":1,
			\ "def":1,
			\ "bat":1,
			\ }


" Change snipmate binding, to avoid problems with jedi-vim
imap <C-i> <Plug>snipMateNextOrTrigger

" tabman shortcuts
let g:tabman_toggle = '<leader>tt'
let g:tabman_focus  = 'tf'

" vim-airline-themes settings
let g:airline_powerline_fonts = 0
let g:airline_theme = 'light'
let g:airline#extensions#whitespace#enabled = 1

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

" ctags
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['.root', '.svn', '.git', '.hg', '.project']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录. 以下配置导致卡死，所以取消
"let s:vim_tags = expand('~/.cache/tags')
"let g:gutentags_cache_dir = s:vim_tags

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']
