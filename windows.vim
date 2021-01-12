language message zh_CN.UTF-8
let g:gutentags_modules = []
let $path = $path.';'.expand('~/vimrc/bin/win32/').';'.expand('~/vimrc/bin/win32/LLVM/').';'.expand('~/vimrc/bin/win32/cppcheck/')
" 避免安装的时候自动安装了python2
set pythondll=
set pythonhome=
set pythonthreehome=~/vimrc/bin/win32/python37
set pythonthreedll=~/vimrc/bin/win32/python37/python37.dll
let g:python3_host_prog = '~/vimrc/bin/win32/python37/python.exe'
