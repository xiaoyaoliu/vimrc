# vimrc
## 第一版是基于以下改的
my custom _vimrc for windows
https://github.com/suprsvn/_vimrc

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

##  tabman 就是tab manager的缩写，管理tab的神器

## conque-term 主要用于在vim中启动各种外部程序，例如shell
参见：https://code.google.com/archive/p/conque/
