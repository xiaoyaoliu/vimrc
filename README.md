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

## 自动补全，Goto功能

### [jedi-vim](https://github.com/davidhalter/jedi-vim) pk [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)

两者都是基于[jedi](https://github.com/davidhalter/jedi)的
可以查找定义，查找所有引用点，查找所有赋值点

* 前者只支持Python; 后者支持更多的语言
* 前者是同步查找，速度慢; 后者架构为client-server，速度快些
* 前者只支持简单补全; 后者可以称为智能补全
* 前者的Goto分为goto_assignment和goto_definition; 后者将goto_declaration和goto_definition合并为了goto_，更加方便
* 前者的安装比较简单; 后者的安装稍为复杂，见[官方文档](https://github.com/Valloric/YouCompleteMe#installation)

所以，最终我还是把jedi-vim替换成了YCM

### YCM的windows安装注意事项

注意根据自己本地的vs版本，设置好命令行参数--msvc 

注意当YCM没有正常工作时，使用如下命令查看log: YcmToggleLogs

### [YCM] python自动补全的大致流程

YcmCompleter [GoTo|GetDoc|RestartServer|...]

YcmCompleter的Subcommands的入口函数都在: jedi_completer.py

ycmd只是作为客户端，具体的py文件的解析定位等都在服务端jediHTTP中

在\_StartServer函数中，启动了jediHTTP服务器

### [YCM] 添加local project的custom path 到jediHTTP服务器的sys.path

为了解决使用YCM无法Goto到一些py文件的问题

我的一个[pull request](https://github.com/vheon/JediHTTP/pull/49)
或者参照[我的jediHTTP fork](https://github.com/xiaoyaoliu/JediHTTP/tree/python_config)
或者看[文档](https://github.com/xiaoyaoliu/JediHTTP/tree/python_config#python-config)

原理是，在启动jediHTTP服务器的时候，执行工程目录下的vimrc.py中函数，该函数会将本地的path加入到sys.path中

这样的话，jediHTTP服务器就可以找到工程下的py文件了。

在project_config中可以找到：我的client工程，server工程对应的vimrc.py文件

##	ctrlp 是查找文件的神器 
参考：https://github.com/kien/ctrlp.vim

_vimrc中的关于ctrlp的各项配置的具体含义直接在vim中:help ctrlp

### 使用ctrlp，有时候搜不到特定文件的原因（看help文件分析出来的）
* ctrlp限制了最大文件数ctrlp_max_files，默认为10000
* ctrlp限制了一次检索的返回结果的最大数量ctrlp_match_window，默认为10
* ctrlp有工作目录模式ctrlp_working_path_mode，所搜文件并不在状态栏右侧显示的文件夹中
* 要搜的文件，其格式可能加入了ctrlp的忽略名单ctrlp_custom_ignore

### ctrlp的优势
* 很好的搜索文件的工具，例如 :CtrlP, :CtrlPMixed
* 适合搜索当前打开的文件(file in buffer)里的内容，例如 :CtrlPLine, :CtrlPBufTagAll

### ctrlp的不足
搜索特定关键词时，无法针对工程目录所有文件，即没有类似grep的功能

### vim-ctrlp-cmdpalette
:CtrlPCmdPalette 使用关键词搜索vim的命令行

##  tabman 就是tab manager的缩写，管理tab的神器

## conque-term 主要用于在vim中启动各种外部程序，例如shell
参见：https://code.google.com/archive/p/conque/

## secureCRT中vim的颜色设置

- 在标签页的标题上右键菜单选择Session Options
- Terminal -> Emulation 中的ANSI Color一定要勾上

monokai颜色插件在ubuntu下不work，删掉即可，.vimrc里已经去掉了。
