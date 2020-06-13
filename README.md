# vimrc

## 坚持学vim的理由

1. 可以ssh直连server改代码。	尤其对于服务端C++程序员而言，vim8的gdb调试很方便。
1.  一次学好，终身受益。		支持几乎所有类型编程语言，换公司也不用从头捣鼓编辑器。
1. 好用的宏录制。				q键可以自定义宏操作，可以节省很多的编辑时间。
1. 句号大法好。					"."可以重复上一个操作，熟练使用后很方便
1. 天花板高，学无止境。			扩展性好，插件库丰富。 配置方式是脚本，对程序员友好。

## linux系统下vim的环境准备

### 安装vim

linux下[vim](https://github.com/vim/vim)的版本过低: vim --version

要求vim 8.0以上, 支持python

#### 在和他人共用的机器上

方式1: [直接用源码安装](https://vi.stackexchange.com/questions/11526/how-to-enable-python-feature-in-vim/17502)
```
# Prepare your system

sudo apt install libncurses5-dev \
python-dev \
python3-dev git

# The directory to install
cd ~ && mkdir sbin

# install: pay attention here check python directory and prefix directory correct
cd /tmp && git clone https://github.com/vim/vim.git && cd vim

 ./configure --enable-multibyte --enable-cscope --enable-farsi\
 --enable-pythoninterp=yes \
 --with-python-config-dir=/usr/lib/python2.7/config-x86_64-linux-gnu/\
 --enable-python3interp=yes \
--with-python3-config-dir=/usr/lib/python3.5/config-3.5m-x86_64-linux-gnu/ \
 --prefix=/home/<username>/sbin

make 

make install

#add to ~/.profile
export PATH="$HOME/sbin/bin:$PATH" 

source ~/.profile

vim --version
```

方式2: 使用: [Linuxbrew](https://github.com/Linuxbrew/brew)

brew install vim

#### 在自己的机器上，直接root权限升级

yum install -y vim

apt-get install vim

也可以直接用源码安装(只列举不同点)

./configure --prefix=/usr

sudo make install

### 安装
```bash
# 下载本项目
cd ~
git clone https://github.com/xiaoyaoliu/vimrc.git
# 使用本项目的vimrc
cp ~/vimrc/default.vimrc ~/.vimrc
# 安装vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
# 打开vim
vim
# reload .vimrc in vim
:source ~/.vimrc
# 在vim中下载安装所有插件
:PlugInstall
```
## windows系统下vim的环境准备

### vim的安装

本文不打算支持32位的windows，所以请直接安装64位的vim

下载地址: https://github.com/vim/vim-win32-installer/releases

### 安装vim-plug

https://github.com/junegunn/vim-plug

Vundle已废弃。因为vim-plug支持异步，且有人维护

### 下载工程
```
cd ~
git clone https://github.com/xiaoyaoliu/vimrc.git
# 使用本项目的vimrc
cp ~/vimrc/default.vimrc ~/_vimrc
```

### 安装插件

打开vim(或gVim)，COMMAND MODE下输入:PlugInstall并回车即可安装全部插件


### windows环境配置

将$HOME/vimrc/bin/win32加入到环境变量Path

* xmllint.exe syntastic插件用于xml格式的检查

测试方法:

Win+R cmd Enter

xmllint

## vim语法检查

### syntastic插件[已废弃]

[Vim 8 下 C/C++ 开发环境搭建](http://www.skywind.me/blog/archives/2084) :代码检查是个好东西，让你在编辑文字的同时就帮你把潜在错误标注出来，不用等到编译或者运行了才发现。我很奇怪 2018 年了，为啥网上还在到处介绍老旧的 syntastic，但凡见到介绍这个插件的文章基本都可以不看了。

老的 syntastic 基本没法用，不能实时检查，一保存文件就运行检查器并且等待半天，所以请用实时 linting 工具 [ALE](https://github.com/w0rp/ale)：https://github.com/w0rp/ale

各种语言的语法检查

集中常见格式的支持(也是在syntastic-checkers.txt 里抄袭的)

每种格式其实有多种工具可以检查语法，以下只列举其中一种，更多工具请:help syntastic-checkers

* xml: xmllint(yum install -y libxml2)
* python: pip install pep8
* cmake: pip install cmakelint
* yaml: pip install yamllint
* cpp: pip install cppclean
* sh: pip install bashate
* json: npm install -g jsonlint
* dockfile:  npm install -g dockerfile_lint
* js: npm install -g jsxhint
* css:  npm install -g csslint
* coffee:  npm install -g coffee-jshint
 

如需更多格式信息, 请查看如下help

:help syntastic-checkers

### ALE插件

#### python配置过程中遇到的问题

* 使用ALEInfoToClipboard，查看ALE的错误信息
  * flake8 failed to load plugin "pycodestyle.break_around_binary_operator" due to 'module' object has no attribute 'break_around_binary_operator'
* pip check
  * 得到 flake8 3.3.0 has requirement pycodestyle<2.4.0,>=2.0.0, but you have pycodestyle 2.5.0
* flake8版本过高导致，降低版本
```
pip install 'flake8>=2.3.0,<2.4.0' --force-reinstall
```
## 自动补全，Goto功能

### snippets插件的用法

这个插件是否好用，输入一些特定的字母，点tab键就可以生成代码模板

每种语言有哪些“暗号”在这个文件夹中定义：.vim\bundle\vim-snippets\snippets

例如python的话就是在python.snippets中定义，查看这个文件可以学到一些技巧。

### ctags（最重要的goto功能）

[Universal Ctags](https://ctags.io/): https://ctags.io/

自动建索引插件[vim-gutentags](https://github.com/ludovicchabant/vim-gutentags): https://github.com/ludovicchabant/vim-gutentags

* (c-w)]	查看函数定义
* (c-])		跳到第一个定义	
* g(c-])	跳到所有的定义
* :tnext	跳到下一个定义	
* ,6		刷新当前工程的ctags的索引

### [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)

可以查找定义，查找所有引用点，查找所有赋值点。其实主要用他的自动补全

所以，最终我还是把jedi-vim替换成了YCM

注意当YCM没有正常工作时，使用如下命令查看log: YcmToggleLogs

#### YCM的windows安装注意事项

注意根据自己本地的vs版本，设置好命令行参数--msvc 

#### [YCM] python自动补全的大致流程

YcmCompleter [GoTo|GetDoc|RestartServer|...]

YcmCompleter的入口def GetSubcommandsMap在: jedi_completer.py

ycmd只是作为客户端，具体的py文件的解析定位等都在服务端jediHTTP中

在\_StartServer函数中，启动了jediHTTP服务器

#### [YCM] 添加local project的custom path 到jediHTTP服务器的sys.path

为了解决使用YCM无法Goto到一些py文件的问题

我的一个[pull request](https://github.com/vheon/JediHTTP/pull/49)
或者参照[我的jediHTTP fork](https://github.com/xiaoyaoliu/JediHTTP/tree/python_config)
或者看[文档](https://github.com/xiaoyaoliu/JediHTTP/tree/python_config#python-config)

原理是，在启动jediHTTP服务器的时候，执行工程目录下的vimrc.py中函数，该函数会将本地的path加入到sys.path中

这样的话，jediHTTP服务器就可以找到工程下的py文件了。

在project_config中可以找到：我的client工程，server工程对应的vimrc.py文件

#### 注意配置ycm_filetype_whitelist的时候，要填python，不要用py

ycm_filetype_whitelist里是filetype不是文件的后缀名。

filetype具体是什么名字，打开对应文件，执行
```
set filetype?
```
## 工程管理，文件管理，全文检索

### airblade/vim-rooter

这个插件会把当前的工程目录设置为working path

可以在一个文件夹里新建文件".git", 从而vim-rooter将这个文件夹识别为工程目录

#### [MattesGroeger/vim-bookmarks](https://github.com/MattesGroeger/vim-bookmarks)

使用mi指令将各个工程的某文件加入到标签列表，启动vim后就可以通过ma指令搜索想打开的工程

###  查找文件
[ctrlp](https://github.com/kien/ctrlp.vim) vs [Leaderf](https://github.com/Yggdroot/LeaderF) vs [fzf](https://github.com/junegunn/fzf.vim)

vimrc中的关于ctrlp的各项配置的具体含义直接在vim中:help ctrlp

#### fzf

对Windows不友好，是弹出来一个cmd窗口进行文件的搜索，无法搜索中文

#### 使用ctrlp，有时候搜不到特定文件的原因（看help文件分析出来的）
* ctrlp限制了最大文件数ctrlp_max_files，默认为10000
* ctrlp限制了一次检索的返回结果的最大数量ctrlp_match_window，默认为10
* ctrlp有工作目录模式ctrlp_working_path_mode，所搜文件并不在状态栏右侧显示的文件夹中
* 要搜的文件，其格式可能加入了ctrlp的忽略名单ctrlp_custom_ignore

#### ctrlp的优势
* 很好的搜索文件的工具，例如 :CtrlP, :CtrlPMixed
* 适合搜索当前打开的文件(file in buffer)里的内容，例如 :CtrlPLine, :CtrlPBufTagAll

#### ctrlp的不足
搜索特定关键词时，无法针对工程目录所有文件，即没有类似grep的功能

#### vim-ctrlp-cmdpalette
:CtrlPCmdPalette 使用关键词搜索vim的命令行

### 全文检索工具 

#### 推荐[rg](https://github.com/BurntSushi/ripgrep) ([Leaderf rg](https://github.com/Yggdroot/LeaderF))

检索速度： [rg](https://github.com/BurntSushi/ripgrep) > [the_silver_searcher](https://github.com/ggreer/the_silver_searcher)([ag.vim](https://github.com/rking/ag.vim)) > ack > grep

rg的[优势](https://ruby-china.org/topics/38001): 速度最快, 支持中文, 异步搜素, 功能最全

windows下安装: choco install ripgrep

#### linux下的手动安装

[rg](https://github.com/BurntSushi/ripgrep#building)

## 小插件简介

### md文件的编辑插件

vim-markdown 编辑

[previm/previm](https://github.com/previm/previm) 用于预览 快捷键: ,8

### tyru/open-browser.vim 可以比较方便地打开浏览器，或者进行搜索

###  tabman 就是tab manager的缩写，管理tab的神器

### [conque-term](https://code.google.com/archive/p/conque/)主要用于在vim中启动各种外部程序，例如shell

启动外部工具，可以vim自带的, 例如

:!cd <path>

### [vim-airline](https://github.com/vim-airline/vim-airline)业界标准底部状态栏

### svn插件[juneedahamed/svnj.vim](https://github.com/juneedahamed/svnj.vim)

svn 最佳使用方式: [Is there a nice subversion plugin for Vim?](https://stackoverflow.com/questions/6905297/is-there-a-nice-subversion-plugin-for-vim)

例如:

:!svn log %

## vim小知识集合

### 命令行中，输入\<C-D\>查看可能的补全结果

例如:

:e \<C-D\>

### :diffsplit

vim自带的比较文件差异的功能

### jumps相关，Ctrl + i, Ctrl + o

Ctrl + o 跳转到光标的历史位置; Ctrl + i则是相反方向

### python取消用4个空格缩进的方法

背景：由于公司编码规范是用tab来缩进，而不是标准的4个空格
1. let g:python_recommended_style = 0
1. 千万不要用这个插件: vim-scripts/indentpython.vim
2. set noexpandtab

### secureCRT中vim的颜色设置

个人电脑上建议用XShell, 比secureCRT更好用

- 在标签页的标题上右键菜单选择Session Options
- Terminal -> Emulation 中的ANSI Color一定要勾上

## 未来与展望

### 关注业界[最流行的vim插件](https://github.com/search?l=Vim+script&o=desc&p=1&q=vim&s=stars&type=Repositories)

将适合我的插件加进来

### 查看vimrc文件，熟练使用已安装的插件

### 小需求汇总

* 不同的项目 使用不同的vimrc，公司内使用公司内的，其他地方使用flake8标准的
* svn 相关的插件

### todolist

* 学习[amix/vimrc](https://github.com/amix/vimrc), 寻找更好用的插件
* 学习[spf13/spf13-vim](https://github.com/spf13/spf13-vim), 寻找更好用的插件
* vim 与 svn git的结合 尤其是blame 查log 以及日常提交
* vim和工程更好的结合
* https://juejin.im/entry/5bced0e1e51d457a1179de96 https://github.com/embear/vim-foldsearch

## 插件黑名单

* 'suan/vim-instant-markdown': 按照文档装完之后打不开，所以废弃
* 'iamcco/markdown-preview.vim': 容易卡死，所以废弃
* 'fisadev/vim-isort': 安装后，启动vim会报错
* vim-scripts/indentpython.vim: 安装后，会导致python无法使用tab进行缩进
* airblade/vim-gitgutter: 安装后，如果一个文件不在git中，直接打开这个文件的时候vim会卡死, 使用<C-c>可以临时解决这个问题

## 扩展阅读
* Vim 8 下 C/C++ 开发环境搭建: http://www.skywind.me/blog/archives/2084
