## vim语法检查

### syntastic插件[已废弃]

<!--[Vim 8 下 C/C++ 开发环境搭建](http://www.skywind.me/blog/archives/2084) :代码检查是个好东西，让你在编辑文字的同时就帮你把潜在错误标注出来，不用等到编译或者运行了才发现。我很奇怪 2018 年了，为啥网上还在到处介绍老旧的 syntastic，但凡见到介绍这个插件的文章基本都可以不看了。-->

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
pip install "flake8>=2.3.0,<2.4.0" --force-reinstall

```
## Goto功能插件GTags(比ctags更强大的工具, 推荐)

Vim 8 中 C/C++ 符号索引：GTags 篇: https://zhuanlan.zhihu.com/p/36279445

安装指导: https://www.cnblogs.com/kuang17/p/9449258.html

### windows下gtags的安装
windows上默认已经装好，如果需要更新gtags到最新版本，则按如下步骤即可

```sh
# 下载gtags, 下载的文件名通常为gloXXXwb.zip
http://adoxa.altervista.org/global/

# 解压gloXXXwb.zip, 得到bin, lib, share三个文件夹

# 把文件copy到vimrc工程中
将bin、lib目录下的所有散文件copy至~/vimrc/bin/win32
将share目录整体直接copy至~/vimrc/bin/

#安装pygments
cd ~\vimrc\bin\win32\python37
python -m pip install pygments

# 最后提交下vimrc工程的修改，并push到github
```
### gtags插件安装失败的调试

错误排查：gutentags: gutentags: gtags-cscope job failed, returned: 1

这说明 gtags 在生成数据时出错了

第一步：判断 gtags 为何失败，需进一步打开日志，查看 gtags 的错误输出：

let g:gutentags_trace = 1

let g:gutentags_define_advanced_commands = 1

先在 vimrc 中添加上面这一句话，允许 gutentags 打开一些高级命令和选项。

然后打开你出错的源文件，运行 “:GutentagsToggleTrace”命令(相当于g:gutentags_trace = 1)打开日志，它会将 ctags/gtags 命令的输出记录在 Vim 的 message 记录里。

*接着保存一下当前文件，触发 gtags 数据库更新*，稍等片刻你应该能看到一些讨厌的日志输出，然后当你碰到问题时在 vim 里调用 ":messages" 命令列出所有消息记录，即可看到 gtags 的错误输出，方便你定位。

### mac下gtags的安装
```sh
# 获取最新版本的gtags源码, 例如6.6.5
wget http://tamacom.com/global/global-x.x.x.tar.gz

# 解压
tar -zxvf global-x.x.x.tar.gz

cd global-x.x.x

./configure

make && make install

cp gtags.conf ~/vimrc/vimplug/

# vim会找$PATH下的python来找pygments，所以干脆两者都装一下
python -m pip install pygments
python3 -m pip install pygments
```
linux下gtags的安装: 步骤和mac下差不多，只是某些步骤需要root权限

由于原生的gtags只支持六种语言: C，C++，Java，PHP4，Yacc，汇编

如想要更多语言，那么 gtags 是支持使用 ctags/universal-ctags 或者 pygments 来作为分析前端支持 50+ 种语言。

本文推荐使用pygments，不必使用ctags

Q: GscopeFind总是失败

A: 尝试清理一下: rm -rf ~/.cache/tags/*

### ctags（最重要的goto功能, 已过时!，obsoleted）

本插件同时支持gtags和ctags，日常使用以gtags为主，ctags为辅助。

[Universal Ctags](https://ctags.io/): https://ctags.io/

自动建索引插件[vim-gutentags](https://github.com/ludovicchabant/vim-gutentags): https://github.com/ludovicchabant/vim-gutentags

* (c-w)]	查看函数定义
* (c-])		跳到第一个定义	
* g(c-])	跳到所有的定义
* :tnext	跳到下一个定义	
* ,6		手动刷新当前工程的gtags的索引
* ,66		手动刷新当前工程的ctags的索引

linux下ctags的安装
```sh
# 下载ctags
git clone https://github.com/universal-ctags/ctags.git

# 安装autotools
sudo apt-get install autoconf automake libtool

# https://github.com/universal-ctags/ctags/blob/master/docs/autotools.rst
cd ctags
./autogen.sh
./configure --prefix=/where/you/want # defaults to /usr/local
make
make install # may require extra privileges depending on where to install
```
## 过时插件

### 文件查找[ctrlp](https://github.com/kien/ctrlp.vim) -> Leaderf

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

### 文件查找[fzf](https://github.com/junegunn/fzf.vim)

对Windows不友好，是弹出来一个cmd窗口进行文件的搜索，无法搜索中文

## 插件黑名单

* 'suan/vim-instant-markdown': 按照文档装完之后打不开，所以废弃
* 'iamcco/markdown-preview.vim': 容易卡死，所以废弃
* 'fisadev/vim-isort': 安装后，启动vim会报错
* vim-scripts/indentpython.vim: 安装后，会导致python无法使用tab进行缩进
* airblade/vim-gitgutter: 安装后，如果一个文件不在git中，直接打开这个文件的时候vim会卡死, 使用<C-c>可以临时解决这个问题
* majutsushi/tagbar: 你真的不需要 tagbar 了，tagbar 是个老牌插件，用来查看函数列表，但是它已经好几年不更新了，经常在不经我许可的情况下（一次都没打开过它），莫名其妙的给我用阻塞方式调用 ctags，有时候切换文件都会卡几秒。https://www.zhihu.com/question/31934850
* 

