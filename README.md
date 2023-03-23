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
```sh
# Prepare your system

sudo apt install libncurses5-dev \
python-dev \
python3-dev git

# The directory to install
cd ~ && mkdir sbin

# install: pay attention here check python directory and prefix directory correct
cd /tmp && git clone https://github.com/vim/vim.git && cd vim

# [https://github.com/vim/vim/issues/3629](https://github.com/vim/vim/issues/3629#issuecomment-440845680)
export LDFLAGS="-rdynamic"

 ./configure --enable-multibyte --enable-cscope --enable-farsi --enable-fail-if-missing -enable-terminal\
 --enable-python3interp=yes \
--with-python3-config-dir=/usr/lib/python3.7/config-3.7m-x86_64-linux-gnu/ \
 --prefix=/home/<username>/sbin

make 

make install

#add to ~/.profile
export PATH="$HOME/sbin/bin:$PATH" 

source ~/.profile

vim --version
```

有些机器默认的python3版本是3.5，
由于YCM插件要求的python版本号最低为3.6，所以最好将python3升级到3.7+
```sh
#到如下网站找到最新的python3版本
https://www.python.org/downloads/

# 下载最新的python3源码
cd ~/tmp
wget https://www.python.org/ftp/python/3.x.x/Python-3.x.x.tar.xz
tar xf Python-3.x.x.tar.xz

# 编译安装
cd Python-3.x.x

./configure --enable-shared --prefix=/home/<username>/sbin

make && make install

# 复制python库到系统目录，便于可以直接使用python3命令
sudo cp ~/sbin/lib/libpython3.x.so.1.0 /usr/lib

# 回到上文，继续安装vim
--with-python3-config-dir=/home/<username>/sbin/lib/python3.x/config-3.x-x86_64-linux-gnu/
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
# windows os
git clone https://github.com/xiaoyaoliu/vimrc.git
# linux or mac
git clone -b linux https://github.com/xiaoyaoliu/vimrc.git
# 使用本项目的vimrc
cp ~/vimrc/default.vimrc ~/.vimrc
# 安装vim-plug
curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
    https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim 
# 打开vim
vim
# reload .vimrc in vim
:source ~/.vimrc

# 某些插件(例如: deoplete, nvim-yarp)依赖pynvim
python3 -m pip install pynvim

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

## 语法检查插件ALE

代码检查是个好东西，让你在编辑文字的同时就帮你把潜在错误标注出来，不用等到编译或者运行了才发现

windows上默认已经支持三种格式的自动检查:python、c/cpp、xml，更多编程语言的检查，参见官方文档

[ALE](https://github.com/w0rp/ale)：https://github.com/w0rp/ale

linux下需要安装语法检查工具，例如:

```bash
apt-get install libxml2-utils # xmllint
```
更多语言的语法支持见: [https://github.com/xiaoyaoliu/vimrc/blob/master/logs.md](https://github.com/xiaoyaoliu/vimrc/blob/master/logs.md)

## Goto功能插件GTags

[gutentags_plus](https://github.com/skywind3000/gutentags_plus)

* \<leader\>js Find this symbol. jump to all references. 跳转到所有相关的引用
* \<leader\>jg jump to definition. 跳转到定义
* \<leader\>ja Find places where this symbol is assigned a value. 找到所有赋值
* \<leader\>jE Find this egrep pattern. 正则匹配查找

## 自动补全

### snippets插件的用法

这个插件是否好用，输入一些特定的字母，点tab键就可以生成代码模板

每种语言有哪些“暗号”在这个文件夹中定义：.vim\bundle\vim-snippets\snippets

例如python的话就是在python.snippets中定义，查看这个文件可以学到一些技巧。

### [YouCompleteMe](https://github.com/Valloric/YouCompleteMe)

可以查找定义，查找所有引用点，查找所有赋值点。其实主要用他的自动补全

所以，最终我还是把jedi-vim替换成了YCM

注意当YCM没有正常工作时，使用如下命令查看log: YcmToggleLogs

#### YCM的windows安装注意事项

注意根据自己本地的vs版本，设置好命令行参数--msvc, msvc默认值是16，对应vs2019

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
### TabNine

一个号称很智能的补全插件，免费版的功能一般，收费版则有代码泄漏的风险！

现在已经用Copilot插件来代替

技巧：如何查看Vim的<TAB>按键被何处占用: :verbose imap <Tab>

## 工程管理，文件管理，全文检索

### airblade/vim-rooter

这个插件会把当前的工程目录设置为working path

可以在一个文件夹里新建文件".git", 从而vim-rooter将这个文件夹识别为工程目录

#### [MattesGroeger/vim-bookmarks](https://github.com/MattesGroeger/vim-bookmarks)

使用\<leader\>mi指令将各个工程的某文件加入到标签列表，启动vim后就可以通过\<leader\>ma指令搜索想打开的工程

###  查找文件[Leaderf](https://github.com/Yggdroot/LeaderF)

Leaderf 是现役插件，如果感觉用的不顺手，可以试试备选插件: https://github.com/liuchengxu/vim-clap

* \<leader\>f 搜索文件。如果想要的文件没搜到，按下F5 刷新缓存！
* \<leader\>fm 搜索MRU文件: 最近用过的文件。
* \<leader\>b 搜索buffer里的文件。
* \<leader\>4 搜索本文件里的函数

小技巧: 弹出搜索窗口的时候，按Tab 键玩一玩


vimrc中的关于ctrlp的各项配置的具体含义直接在vim中:help ctrlp

#### 使用Leaderf搜索本文件函数的技巧

其次 LeaderfFunction 有两种模式：浏览模式和模糊匹配模式，我们直接用 \<leader\>4 进入浏览模式浏览当前文档的函数：

```vim
<leader>4 :LeaderfFunction!<cr>
```

命令后加一个叹号会进入 normal 模式，就跟tagbar一样，除了上下键选择外，Vim的各种跳转和搜索命令都可以始用，回车就跳转过去。

在 LeaderfFunction 的浏览模式中，按 i 进入模糊匹配模式（按 TAB切换回来）：

Q1: [中文文件名乱码的问题](https://github.com/Yggdroot/LeaderF/issues/203)

A1: 这是git的问题，可以这样：

git config --global core.quotepath false

### 全文检索工具 [rg](https://github.com/BurntSushi/ripgrep) ([Leaderf rg](https://github.com/Yggdroot/LeaderF))

检索速度： [rg](https://github.com/BurntSushi/ripgrep) > [the_silver_searcher](https://github.com/ggreer/the_silver_searcher)([ag.vim](https://github.com/rking/ag.vim)) > ack > grep

rg的[优势](https://ruby-china.org/topics/38001): 速度最快, 支持中文, 异步搜素, 功能最全

所有的Leaderf的窗口都支持Tab 键！！

当按Tap 键进入浏览模式后，按下p键试试预览功能

windows下安装: choco install ripgrep

linux下的手动安装: [rg](https://github.com/BurntSushi/ripgrep#building)

常用搜索快捷键如下，更多快捷键请阅读plugins_config.vim:

```vim
<leader>rr 正常的文本搜索: 搜索的关键词包含大写字母则区分大小写，否则不区分大小写
<leader>rw 正常的文本搜索 + 全字匹配
<leader>wr 搜索选中的单词

#### rg搜索结果不全的排查步骤
1. 确保当前目录下的.gitignore文件中没有忽略目标
1. 先脱离vim，直接用命令行搜索：首先看结果全不全，其次要确认程序的正常退出（ExitCode == 0）。windows下: echo %ERRORLEVEL%
2. rg的逻辑: https://github.com/Yggdroot/LeaderF/blob/master/autoload/leaderf/python/leaderf/rgExpl.py

经验记录
1. 是因为被.gitignore给忽略了
1. 是ExitCode是1，没有正常退出，后来更新rg的版本到最新得以解决。
```
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

竞品: https://github.com/powerline/powerline

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

## 扩展阅读
* Vim 8 下 C/C++ 开发环境搭建: http://www.skywind.me/blog/archives/2084
