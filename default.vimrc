source ~/vimrc/basic.vim
if has("win16") || has("win32")
    source ~/vimrc/windows.vim
else
    source ~/vimrc/linux.vim
endif
source ~/vimrc/plugins_config.vim
source ~/vimrc/python.vim
