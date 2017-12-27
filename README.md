# vimrc
## 第一版是基于以下改的
my custom _vimrc for windows
https://github.com/suprsvn/_vimrc

### 安装vundle
linux vundle的安装：https://github.com/VundleVim/Vundle.vim

windows vundle的安装：https://github.com/VundleVim/Vundle.vim/wiki/Vundle-for-Windows

### BundleInstall
打开vim(或gVim)，COMMAND MODE下输入:BundleInstall并回车即可安装全部插件

## python取消用4个空格缩进的方法
背景：由于公司编码规范是用tab来缩进，而不是标准的4个空格

参考：https://vi.stackexchange.com/questions/10124/what-is-the-difference-between-filetype-plugin-indent-on-and-filetype-indent

1. 在vim中执行：:help :filetype-overview
2. 然后查找py文件的一些help信息：let g:python_recommended_style = 0
3. 在_vimrc中添加这行命令即可

## snippets插件的用法

这个插件是否好用，输入一些特定的字母，点tab键就可以生成代码模板

每种语言有哪些“暗号”在这个文件夹中定义：.vim\bundle\vim-snippets\snippets

例如python的话就是在python.snippets中定义，查看这个文件可以学到一些技巧。

## jedi插件，查找引用关系的神器

在_vimrc中搜索jedi，即可找到对应的快捷键

可以查找定义，查找所有引用点，查找所有赋值点

##	ctrlp 是查找文件的神器 
参考：https://github.com/kien/ctrlp.vim

_vimrc中的关于ctrlp的各项配置的具体含义直接在vim中:help ctrlp

### 使用ctrlp，有时候搜不到特定文件的原因（看help文件分析出来的）
* ctrlp限制了最大文件数ctrlp_max_files，默认为10000
* ctrlp限制了一次检索的返回结果的最大数量ctrlp_match_window，默认为10
* ctrlp有工作目录模式ctrlp_working_path_mode，所搜文件并不在状态栏右侧的文件夹中
* 要搜的文件，其格式可能加入了ctrlp的忽略名单ctrlp_custom_ignore

### ctrlp的优势
* 很好的搜索文件的工具，例如 :CtrlP, :CtrlPMixed
* 适合搜索当前打开的文件(file in buffer)里的内容，例如 :CtrlPLine, :CtrlPBufTagAll

### ctrlp的不足
搜索特定关键词时，无法针对工程目录所有文件，即没有类似grep的功能

##  tabman 就是tab manager的缩写，管理tab的神器

## conque-term 主要用于在vim中启动各种外部程序，例如shell
参见：https://code.google.com/archive/p/conque/

## secureCRT中vim的颜色设置

- 在标签页的标题上右键菜单选择Session Options
- Terminal -> Emulation 中的ANSI Color一定要勾上

monokai颜色插件在ubuntu下不work，删掉即可，.vimrc里已经去掉了。
