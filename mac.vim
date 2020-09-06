map <leader>fe :silent !open -R %<CR>
let $GTAGSCONF = '/usr/local/share/gtags/gtags.conf'

" 将自动生成的 tags 文件全部放入 ~/.cache/tags 目录中，避免污染工程目录. 以下配置导致卡死，所以取消
let g:gutentags_cache_dir = expand('~/.cache/tags')
