# vimrc
## 第一版是基于以下改的
my custom _vimrc for windows
https://github.com/suprsvn/_vimrc
##
## python取消用4个空格缩进的方法
背景：由于公司编码规范是用tab来缩进，而不是标准的4个空格
参考：https://vi.stackexchange.com/questions/10124/what-is-the-difference-between-filetype-plugin-indent-on-and-filetype-indent
1、在vim中执行：:help :filetype-overview
2、然后查找py文件的一些help信息：let g:python_recommended_style = 0
3、在_vimrc中添加这行命令即可
