## Step 1：目标Error
分析BuildLog_Win64_Test.txt文件内的cpp编译Error，只关注第一个编译Error，并将其修复。

ripgrep在: `~\background_agent_cli\bin\rg.exe` 或 `~\scoop\shims\rg.exe`
rg必须使用的参数有: 
1. -n : Print line numbers
2. -C N : Show N lines before and after each match
优先使用skill[ripgrep-search]来查找Error或其他regex pattern，而不是扫描整个文件。

满足以下任意条件则就不用执行后续所有Step，请直接果断地结束退出：
1. 你没找到rg程序 且 你无法使用skill[ripgrep-search]，请立即退出
2. 你千万不要尝试自己编译，当你想自己编译或静态语法分析来找Error的时候，你就立即终止退出
3. 你只能在BuildLog_Win64_Test.txt寻找Error，你试图想从Intermediate目录或其他地方寻找Error时，请立即终止退出
4. 你没找到Error，Log的末尾几行包含关键字：Build exceeded timeout，请你立即终止退出

## Step 2： 修复方案
最佳修复方法限制：只改一个cpp后缀的文件，且只能通过新增include头文件的方式来修复编译错误。假设待修改的Cpp文件是B，要include进来的头文件是A，你的include A绝对不能是这个B文件里的第一个include宏。

Fallback方案：如果A头文件必须是B文件里的第一个include宏，那么优先考虑在头文件里加前置声明以绕过这个问题。

最差方案：若你必须在某一个header文件(设定为C头文件)里加include A头文件，那么你必须避免(间接)循环依赖：确定A头文件不会直接或间接依赖C头文件。

除了上述三种方案，你不能有其他类型的代码修改。

每个提交最多修改一个头文件 + 最多一个cpp文件，必须严格遵守；如果有头文件循环依赖，可放宽为2个头文件 + 一个cpp文件。

可以间接引用A头文件：根据报错信息里的符号，分析同Module其他引用此符号的文件是如何include的，总之include的代码正斜杠/越少越好。

新增include的行的限制：不要包括反斜杠\；正斜杠/的数量不要超过3个，可以没有。优先参考B文件的同Module内的cpp/h引用方式; 同Module内如果多处引用A，则优先参考正斜杠/最少的include处。

满足以下任意条件则跳过Step3，不做任何修改，直接果断地结束退出。
1. 无法按上述限制来修复.

## Step3: 创建Pending CL并修复
p4修改描述的限制: 
1. 开头必须是：[@dozhang]
2. 结尾是: 流水线链接

可以不加注释，如果需要注释：Engine目录的代码， 用 maple @dozhang；其他目录的代码，则用@dozhang。必须是English，不能有中文。

编辑文件时候，必须使用编码: utf-8 (no bom)

通过p4 Cmd（参考下面的模板A，不要用powershell）新建一个Pending的ChangeList，简称CL，这个CL输出的文件在工作目录的`pending_cl.txt`, 格式是纯数字。

模板A Begin
@echo off

> cl.txt echo Change: new
>> cl.txt echo.
>> cl.txt echo Description:
>> cl.txt echo   <替换为：你的修改描述>

for /f "tokens=2" %%C in ('p4 change -i ^< cl.txt') do set CL=%%C

del cl.txt

p4 edit -c %CL% <替换为你要修改的cpp/h文件路径>

<执行你的修改方案>

echo %CL% > pending_cl.txt

echo File checked out in changelist %CL%

模板A End