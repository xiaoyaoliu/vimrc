## Step 1：目标Error
分析BuildLog_Linux_Test.txt文件内的cpp编译Error，只关注第一个编译Error，并将其修复。
多看几个Error，如果有和第一个Error同文件的Error，也要一起修复。
<UserName> 默认是Administrator
ripgrep在: `C:\Users\<UserName>\background_agent_cli\bin\rg.exe` 或 `C:\Users\<UserName>\scoop\shims\rg.exe`
rg必须使用的参数有: 
1. -n : Print line numbers
2. -C N : Show N lines before and after each match
优先使用skill[ripgrep-search]来查找Error、搜代码、其他regex pattern，而不是Read整个文件。

还是优先找Error去修哈，如果找不到编译Error，Fallback的目标：编译可能开启了 -WarningsAsErrors，看下最后一个Warning，修最后一个Warning。

满足以下任意条件则就不用执行后续所有Step，请直接果断地结束退出：
1. 你没找到rg程序 且 你无法使用skill[ripgrep-search]，请立即退出
2. 你千万不要尝试自己编译，当你想自己编译或静态语法分析来找Error的时候，你就立即终止退出
3. 你只能在分析BuildLog_Linux_Test.txt寻找Error，你试图想从Intermediate目录或其他地方寻找Error时，请立即终止退出
4. 你没找到Error，Log的末尾几行包含关键字：Build exceeded timeout，请你立即终止退出

## Step 2： 修复方案
最佳方法：最好只改一个cpp后缀的文件，次优只改一个头文件；通过修改PLATFORM_LINUX相关宏的方式来修复；可以删除宏, 移动宏, 新增宏, 修改越小越好。

Fallback方案：不使用PLATFORM_LINUX宏，按照你分析的最优方案修复这个Error，但是绝对不可以删除代码！

注意要具备同一个文件的联想能力，假设你修改的文件是A，例如：
1. 你在文件A里给一些头文件加了PLATFORM_LINUX宏，那么你要找到文件A里这些头文件的关联代码，也确认没问题
2. 你在文件A发现某行有个符号需要加Linux宏，你要检查文件A其他行是不是也使用了类似符号，也要确认没问题

总之你的修改，影响的代码行数越少越好。

每个提交最多修改一个头文件 + 最多一个cpp文件，必须严格遵守

满足以下任意条件则跳过Step3，不做任何修改，直接果断地结束退出。
1. 无法按上述限制来修复.
2. 修复方案会删除代码。

## Step3: 创建Pending CL并修复
p4修改描述的限制: 
1. 开头必须是：[@dozhang]
2. 结尾是: 流水线链接

可以不加注释，如果需要注释：Engine目录的代码， 用 maple @dozhang；其他目录的代码，则用@dozhang; CL 描述本身只需以 [@dozhang] 开头。注释和CL描述必须是English，不能有中文。

编辑文件时候，必须使用编码: utf-8 (no bom)

所有命令优先通过 cmd.exe 执行，尽量不用 PowerShell： powershell不支持&，请用;代替
如需通过 terminal 工具执行命令，请在命令前加 `cmd /c` 前缀。

通过p4 Cmd（参考下面的模板A）新建一个Pending的ChangeList，简称CL，这个CL输出的文件在工作目录的`pending_cl.txt`, 格式是纯数字。

模板A Begin
@echo off

> cl.txt echo Change: new
>> cl.txt echo.
>> cl.txt echo Description:
>> cl.txt echo   <替换为：你的修改描述>

for /f "tokens=2" %%C in ('p4 change -i ^< cl.txt') do set CL=%%C

del cl.txt

p4 edit -c %CL% <替换为你要修改的cpp/h文件路径>

<执行你的修改方案: 使用 replace_in_file/edit_file 修改文件内容>

cmd /c "set /p=%CL% <nul > pending_cl.txt"

echo File checked out in changelist %CL%

模板A End