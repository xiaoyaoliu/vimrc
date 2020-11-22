source ~/vimrc/basic.vim
if has("win32")
    source ~/vimrc/windows.vim
else
    source ~/vimrc/linux.vim
endif

if has("macunix")
    source ~/vimrc/mac.vim
endif 

source ~/vimrc/plugins_config.vim
source ~/vimrc/python.vim

if has("win32")
    source ~/vimrc/windows_post.vim
else
    source ~/vimrc/linux_post.vim
endif

if has("macunix")
    source ~/vimrc/mac_post.vim
endif 

