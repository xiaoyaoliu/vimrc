### R 语言 与 Spss

R安装包: https://mirrors.tuna.tsinghua.edu.cn/CRAN/bin/windows/base/

SPSS和R语言插件: https://github.com/IBMPredictiveAnalytics/R_Essentials_Statistics/releases

从上图可以看出，R3.6至少要搭配SPSS 27，R3.5至少要搭配SPSS 26，SPSS 25只能用R3.3

安装好SPSS的R语言插件后，需要在SPSS的菜单栏里配置下R语言的根目录了：扩展-> R3.X配置

### R 语言 Packages安装

最基本的安装命令, 以Pacakge abind为例

```R
install.packages("abind") 
```

Q: 使用基本的安装命令，中间会弹出对话框，询问你是否从源代码安装？
A: 通常来说，直接选择不从源代码安装；但是如果选择否之后不成功，那就从选择从源码安装试试看。


### Package not available 或者 compile failed

以Package lme4为例

```R
install.packages("lme4") 
```

对于R3.3 会返回如下内容
```log
程序包安装入‘C:/Users/XXX/Documents/R/win-library/3.3’
(因为‘lib’没有被指定)
Warning: 无法在貯藏處https://mirrors.sjtug.sjtu.edu.cn/cran/bin/windows/contrib/3.3中读写索引:
  无法打开URL'https://mirrors.sjtug.sjtu.edu.cn/cran/bin/windows/contrib/3.3/PACKAGES'
Warning message:
package ‘lme4’ is not available (for R version 3.3.3) 
```

对于R3.5 选择从源代码编译，会返回如下内容

```log
c:/Rtools/mingw_32/bin/g++ -shared -s -static-libgcc -o nloptr.dll tmp.def init_nloptr.o nloptr.o test-C-API.o test-runner.o -L../windows/nlopt-2.7.1/lib/i386 -lnlopt -LC:/PROGRA~1/R/R-35~1.3/bin/i386 -lR
../windows/nlopt-2.7.1/lib/i386/libnlopt.a(ags.cc.obj):(.text+0xb9a): undefined reference to `std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_construct(unsigned int, char)'
../windows/nlopt-2.7.1/lib/i386/libnlopt.a(solver.cc.obj):(.text+0x322): undefined reference to `std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_create(unsigned int&, unsigned int)'
../windows/nlopt-2.7.1/lib/i386/libnlopt.a(local_optimizer.cc.obj):(.text+0xa1): undefined reference to `std::__cxx11::basic_string<char, std::char_traits<char>, std::allocator<char> >::_M_create(unsigned int&, unsigned int)'
collect2.exe: error: ld returned 1 exit status
no DLL was created
ERROR: compilation failed for package 'nloptr'
* removing 'C:/Users/l/Documents/R/win-library/3.5/nloptr'
In R CMD INSTALL

```

Q: R3.3 not available，R3.5 compile failed，怎么办?

A: 直接下载二进制包安装

### 直接下载二进制包安装

二进制package都在哪里(where): https://mirrors.tuna.tsinghua.edu.cn/CRAN/

在上面的网页里，选择contrib或old contrib，找到你所需的R版本

R3.5二进制包链接: https://cran-archive.r-project.org/bin/windows/contrib/3.5/

R3.3二进制包链接: https://cran-archive.r-project.org/bin/windows/contrib/3.3/

如何安装呢, 以R3.3为例

```R
download.file("https://cran-archive.r-project.org/bin/windows/contrib/3.3/lme4_1.1-17.zip", "lme4_1.1-17.zip")

install.packages("lme4_1.1-17.zip")

```
安装package nloptr的时候，会报如下错误
```log
程序包‘nloptr’打开成功，MD5和检查也通过
Warning: 无法将临时安装‘C:\Users\xxx\Documents\R\win-library\3.3\file55e4184e7aea\nloptr’搬到‘C:\Users\xxx\Documents\R\win-library\3.3\nloptr’
```

Q: 怎么处理这个Warning呢？
A: 打开目录C:\Users\xxx\Documents\R\win-library\3.3\，手动创建nloptr文件夹后，再次尝试安装package nloptr

### 如何验证一个package是否安装成功

使用library命令来验证，以package lme4为例

```R
library("lme4")
```

如果执行library命令后，没有任何输出，那么恭喜你，package lme4你安装成功啦

如果返回类似如下log
```log
载入需要的程辑包：Matrix
Error in loadNamespace(j <- i[[1L]], c(lib.loc, .libPaths()), versionCheck = vI[[j]]) : 
  不存在叫‘minqa’这个名字的程辑包
错误: ‘lme4’程辑包或名字空间载入失败，

```
Q: 上述错误如何处理呢？
A: 继续安装依赖包: package minqa


Q: 如何安装package minqa呢
A: 参照本文前面几节说的方法

