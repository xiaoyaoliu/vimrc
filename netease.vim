set noexpandtab

map <leader>xl :tabnew ../log.txt<cr>

au BufNewFile,BufRead *.object set filetype=xml
au BufNewFile,BufRead *.ngim set filetype=xml
au BufNewFile,BufRead *.gim set filetype=xml
au BufNewFile,BufRead *.mtg set filetype=xml
au BufNewFile,BufRead *.animationlist set filetype=xml
au BufNewFile,BufRead *.gim set filetype=xml
au BufNewFile,BufRead *.col set filetype=xml
au BufNewFile,BufRead *.blt set filetype=xml
au BufNewFile,BufRead *.uplugin set filetype=json
au BufNewFile,BufRead *.uproject set filetype=json

"function! CheckUpdate(timer)
    "silent! checktime
    "call timer_start(3000,'CheckUpdate')
"endfunction

"au BufNewFile,BufRead *.txt call timer_start(1, 'CheckUpdate')
