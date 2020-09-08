"""""""""""""""""""""""""vundle setting""""""""""""""""""""
set nocompatible  " 去除VI一致性,vundle必须
filetype off                  " 必须

" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

"""""""""""""""""""""""""install packages""""""""""""""""""
Plug 'junegunn/vim-plug'
Plug 'junegunn/vim-easy-align'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/L9'
Plug 'vim-scripts/FuzzyFinder'
Plug 'scrooloose/nerdcommenter'
Plug 'kien/ctrlp.vim'
Plug 'fisadev/vim-ctrlp-cmdpalette'
"Python syntax highlighting script for Vim
Plug 'hdima/python-syntax'
if has('python') || has('python3')
    Plug 'Yggdroot/LeaderF'
    Plug 'rdnetto/YCM-Generator', { 'branch': 'stable'}
    Plug 'Valloric/YouCompleteMe'
    "https://tabnine.com/install
    Plug 'zxqfl/tabnine-vim'
	if has('nvim')
		Plug 'Shougo/defx.nvim', { 'do': ':UpdateRemotePlugins' }
	else
		Plug 'Shougo/deoplete.nvim'
		Plug 'Shougo/defx.nvim'
		Plug 'roxma/nvim-yarp'
		Plug 'roxma/vim-hug-neovim-rpc'
	endif
else
    Plug 'mileszs/ack.vim'
    Plug 'rking/ag.vim'
	Plug 'scrooloose/nerdtree'
endif
Plug 'ludovicchabant/vim-gutentags'
Plug 'skywind3000/gutentags_plus'
Plug 'skywind3000/vim-preview'
Plug 'godlygeek/tabular'
Plug 'plasticboy/vim-markdown'
Plug 'MattesGroeger/vim-bookmarks'
Plug 'mattn/emmet-vim'
Plug 'mhinz/vim-signify'
Plug 'motemen/git-vim'
Plug 'kien/tabman.vim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'rosenfeld/conque-term'
Plug 'fisadev/FixedTaskList.vim'
Plug 'tpope/vim-surround'
Plug 'michaeljsmith/vim-indent-object'
Plug 'MarcWeber/vim-addon-mw-utils'
Plug 'tomtom/tlib_vim'
Plug 'honza/vim-snippets'
Plug 'garbas/vim-snipmate'
Plug 'tpope/vim-fugitive'
Plug 'juneedahamed/svnj.vim'
Plug 'nvie/vim-flake8'
Plug 'w0rp/ale'
Plug 'vim-scripts/IndexedSearch'
Plug 'vim-scripts/matchit.zip'
Plug 'vim-scripts/YankRing.vim'
Plug 'vim-scripts/xptemplate'
"Plug 'vim-scripts/AutoComplPop'
"Plug 'vim-scripts/Wombat'
Plug 'chriskempson/base16-vim'
Plug 'vim-scripts/rainbow_parentheses.vim'
Plug 'Yggdroot/indentLine'
Plug 'xiaoyaoliu/vim-rooter'
"Plug 'vim-scripts/LogViewer'
Plug 'inkarkat/vim-ingo-library'
Plug 'inkarkat/vim-LogViewer'
Plug 'skywind3000/asyncrun.vim'
Plug 'Maxlufs/LargeFile.vim'

if has("win16") || has("win32")
    Plug 'lsdr/monokai'
    Plug 'previm/previm'
    Plug 'tyru/open-browser.vim'
    Plug 'haya14busa/vim-open-googletranslate'
endif
" python plugins
"Plug 'fs111/pydoc.vim'

" 你的所有插件需要在下面这行之前
" Initialize plugin system
call plug#end()
" Enable filetype plugins
filetype plugin indent on    " 必须 加载vim自带和插件相应的语法和文件类型相关脚本

" 自动打开 quickfix window ，高度为 6
let g:asyncrun_open = 6

" 任务结束时候响铃提醒
let g:asyncrun_bell = 1

" 设置 F10 打开/关闭 Quickfix 窗口
nnoremap <F10> :call asyncrun#quickfix_toggle(6)<cr>

" toggle Tagbar display
nmap <leader>4 :LeaderfFunction!<CR>i

" NERDTree (better file browser) toggle
"
if has('python') || has('python3')
	let g:deoplete#enable_at_startup = 1
	nmap <leader>3 :vsplit<CR>:Defx<CR>
	autocmd FileType defx call s:defx_my_settings()
	function! s:defx_my_settings() abort
	  " Define mappings
	  nnoremap <silent><buffer><expr> <CR>
	  \ defx#do_action('open')
	  nnoremap <silent><buffer><expr> c
	  \ defx#do_action('copy')
	  nnoremap <silent><buffer><expr> m
	  \ defx#do_action('move')
	  nnoremap <silent><buffer><expr> p
	  \ defx#do_action('paste')
	  nnoremap <silent><buffer><expr> l
	  \ defx#do_action('open')
	  nnoremap <silent><buffer><expr> E
	  \ defx#do_action('open', 'vsplit')
	  nnoremap <silent><buffer><expr> P
	  \ defx#do_action('preview')
	  nnoremap <silent><buffer><expr> o
	  \ defx#do_action('open_tree', 'toggle')
	  nnoremap <silent><buffer><expr> K
	  \ defx#do_action('new_directory')
	  nnoremap <silent><buffer><expr> N
	  \ defx#do_action('new_file')
	  nnoremap <silent><buffer><expr> M
	  \ defx#do_action('new_multiple_files')
	  nnoremap <silent><buffer><expr> C
	  \ defx#do_action('toggle_columns',
	  \                'mark:indent:icon:filename:type:size:time')
	  nnoremap <silent><buffer><expr> S
	  \ defx#do_action('toggle_sort', 'time')
	  nnoremap <silent><buffer><expr> d
	  \ defx#do_action('remove')
	  nnoremap <silent><buffer><expr> r
	  \ defx#do_action('rename')
	  nnoremap <silent><buffer><expr> !
	  \ defx#do_action('execute_command')
	  nnoremap <silent><buffer><expr> x
	  \ defx#do_action('execute_system')
	  nnoremap <silent><buffer><expr> yy
	  \ defx#do_action('yank_path')
	  nnoremap <silent><buffer><expr> .
	  \ defx#do_action('toggle_ignored_files')
	  nnoremap <silent><buffer><expr> ;
	  \ defx#do_action('repeat')
	  nnoremap <silent><buffer><expr> h
	  \ defx#do_action('cd', ['..'])
	  nnoremap <silent><buffer><expr> ~
	  \ defx#do_action('cd')
	  nnoremap <silent><buffer><expr> q
	  \ defx#do_action('quit')
	  nnoremap <silent><buffer><expr> <Space>
	  \ defx#do_action('toggle_select') . 'j'
	  nnoremap <silent><buffer><expr> *
	  \ defx#do_action('toggle_select_all')
	  nnoremap <silent><buffer><expr> j
	  \ line('.') == line('$') ? 'gg' : 'j'
	  nnoremap <silent><buffer><expr> k
	  \ line('.') == 1 ? 'G' : 'k'
	  nnoremap <silent><buffer><expr> <C-l>
	  \ defx#do_action('redraw')
	  nnoremap <silent><buffer><expr> <C-g>
	  \ defx#do_action('print')
	  nnoremap <silent><buffer><expr> cd
	  \ defx#do_action('change_vim_cwd')
	endfunction
else
	nmap <leader>3 :NERDTreeToggle<CR>

	" Ignore files on NERDTree
	let NERDTreeIgnore = ['\.pyc$', '\.pyo$', '\.lnk$']

endif

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

    " YouCompleteMe customizations
    nmap <leader>jk :YcmCompleter GetDoc<CR>
    let g:ycm_key_invoke_completion = '<c-m>'
    "let g:ycm_seed_identifiers_with_syntax = 0
    let g:ycm_show_diagnostics_ui = 0
    let g:ycm_collect_identifiers_from_tags_files = 1
    let g:ycm_min_num_identifier_candidate_chars = 1
    let g:ycm_complete_in_strings=1
    let g:ycm_collect_identifiers_from_comments_and_strings = 1
    let g:ycm_filetype_whitelist = {
                \ "c":1,
                \ "cpp":1,
                \ "objc":1,
                \ "sh":1,
                \ "zsh":1,
                \ "zimbu":1,
                \ "python":1,
                \ "java":1,
                \ "go":1,
                \ "erlang":1,
                \ "perl":1,
                \ "def":1,
                \ "lua":1,
                \ "cs":1,
                \ "javascript":1,
                \ "dosbatch":1,
                \ "vim":1,
                \ }

    " 加载项目配置的ycm的时候，不弹出确认窗口
    let g:ycm_confirm_extra_conf = 0
    "let g:ycm_semantic_triggers =  {
                "\ 'c,cpp,python,java,go,erlang,perl': ['re!\w{2}'],
                "\ 'cs,lua,javascript': ['re!\w{2}'],
                "\ }

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

" syntastic
let g:ale_linters_explicit = 1
let g:ale_completion_delay = 500
let g:ale_echo_delay = 20
let g:ale_lint_delay = 500
let g:ale_echo_msg_format = '[%linter%] %code: %%s'
let g:ale_lint_on_text_changed = 'normal'
let g:ale_lint_on_insert_leave = 1
let g:ale_lint_on_save = 1
let g:ale_lint_on_enter = 0
let g:airline#extensions#ale#enabled = 1
"let g:ale_fix_on_save = 1

let g:ale_c_gcc_options = '-Wall -O2 -std=c99'
let g:ale_cpp_gcc_options = '-Wall -O2 -std=c++14'
let g:ale_c_cppcheck_options = ''
let g:ale_cpp_cppcheck_options = ''
" Check Python files with flake8 and pylint.
let g:ale_linters = {
\	'python': ['flake8']
\}
" In ~/.vim/vimrc, or somewhere similar.
let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'javascript': ['eslint'],
\   'python': ['autopep8', 'yapf'],
\}
" Change snipmate binding, to avoid problems with jedi-vim
imap <C-i> <Plug>snipMateNextOrTrigger

" tabman shortcuts
let g:tabman_toggle = '<leader>ta'
let g:tabman_focus  = '<leader>tf'

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

" 同时开启 ctags 和 gtags 支持, windows下只开启gtags(避免gutentags生成ctags的卡顿)：
let g:gutentags_modules = []
if executable('ctags') && !has('win32')
	" win32下，设置g:gutentags_cache_dir = expand('~/.cache/tags')，且用ctags，会造成C+]卡顿，
	let g:gutentags_modules += ['ctags']
endif

" enable gtags module
if executable('gtags-cscope') && executable('gtags')
	let g:gutentags_modules += ['gtags_cscope']
	" 第一个 GTAGSLABEL 告诉 gtags 默认 C/C++/Java 等六种原生支持的代码直接使用 gtags 本地分析器，而其他语言使用 pygments 模块。
	let $GTAGSLABEL = 'native-pygments'
	" GTAGSCONF主要告诉gtags，其他50多种语言需要分析哪些文件
	let $GTAGSCONF = expand('~/vimrc/vimplug/gtags.conf')
    "0 or s: Find this symbol
    noremap <silent> <leader>js :GscopeFind s <C-R><C-W><cr>
    noremap <silent> <leader>jS :GscopeFind s 
    "1 or g: Find this definition
    noremap <silent> <leader>jg :GscopeFind g <C-R><C-W><cr>
    noremap <silent> <leader>jG :GscopeFind g 
    "3 or c: Find functions calling this function
    noremap <silent> <leader>jc :GscopeFind c <C-R><C-W><cr>
    noremap <silent> <leader>jC :GscopeFind c 
    "4 or t: Find this text string
    noremap <silent> <leader>jt :GscopeFind t <C-R><C-W><cr>
    noremap <silent> <leader>jT :GscopeFind t 
    "6 or e: Find this egrep pattern
    noremap <silent> <leader>je :GscopeFind e <C-R><C-W><cr>
    noremap <silent> <leader>jE :GscopeFind e 
    "7 or f: Find this file
    noremap <silent> <leader>jf :GscopeFind f <C-R>=expand("<cfile>")<cr><cr>
    noremap <silent> <leader>jF :GscopeFind f 
    "8 or i: Find files #including this file
    noremap <silent> <leader>ji :GscopeFind i <C-R>=expand("<cfile>")<cr><cr>
    noremap <silent> <leader>jI :GscopeFind i 
    "2 or d: Find functions called by this function
    noremap <silent> <leader>jd :GscopeFind d <C-R><C-W><cr>
    noremap <silent> <leader>jD :GscopeFind d 
    "9 or a: Find places where this symbol is assigned a value
    noremap <silent> <leader>ja :GscopeFind a <C-R><C-W><cr>
    noremap <silent> <leader>jA :GscopeFind a 
    "Find current word in ctags database
    noremap <silent> <leader>jz :GscopeFind z <C-R><C-W><cr>
    noremap <silent> <leader>jZ :GscopeFind z 

endif

let g:rooter_patterns = ['_darcs', '.root', '.git', '.svn', '*.sln', 'build/env.sh']

" ctags
" gutentags 搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
let g:gutentags_project_root = ['_darcs', '.root', '.git', '.hg', '.project', '.svn']

" 所生成的数据文件的名称
let g:gutentags_ctags_tagfile = '.tags'

" generate datebases in my cache directory, prevent gtags files polluting my project

" change focus to quickfix window after search (optional).
let g:gutentags_plus_switch = 1

" You can disable the default keymaps by:
let g:gutentags_plus_nomap = 1

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录. 以下配置导致卡死，所以取消
"let s:vim_tags = expand('~/.cache/tags')
"let g:gutentags_cache_dir = s:vim_tags
let g:gutentags_cache_dir = expand('~/.cache/tags')

" 配置 ctags 的参数
let g:gutentags_ctags_extra_args = ['--fields=+niazS', '--extra=+q']
let g:gutentags_ctags_extra_args += ['--c++-kinds=+px']
let g:gutentags_ctags_extra_args += ['--c-kinds=+px']

" 禁用 gutentags 自动加载 gtags 数据库的行为
let g:gutentags_auto_add_gtags_cscope = 0

"enable debug
"let g:gutentags_trace = 1
let g:gutentags_define_advanced_commands = 1

" refesh gtags
:nnoremap <silent> <leader>6 :GutentagsUpdate<CR>

"vim-preview
autocmd FileType qf nnoremap <silent><buffer> p :PreviewQuickfix<cr>
autocmd FileType qf nnoremap <silent><buffer> P :PreviewClose<cr>

" log viewer
let g:LogViewer_SyncUpdate = 'CursorMoved'
"let g:LogViewer_SyncUpdate = 'CursorHold'
let g:LogViewer_Filetypes = 'log4j,syslog,log,txt'

"vim-bookmarks
"disable all default key bindings by setting
let g:bookmark_no_default_key_mappings = 1
nmap <leader>mm <Plug>BookmarkToggle
nmap <leader>mi <Plug>BookmarkAnnotate
nmap <leader>ma <Plug>BookmarkShowAll
