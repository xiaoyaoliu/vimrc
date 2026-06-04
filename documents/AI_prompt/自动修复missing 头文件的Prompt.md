分析BuildLog_Win64_Test.txt文件内的cpp编译错误，只关注第一个编译错误，并将其修复。

修复方法限制：每次修复最多只能改一个cpp后缀的文件，且只能通过新增include头文件的方式来修复编译错误。假设待修改的Cpp文件是B，要include进来的头文件是A，你的include A绝对不能是这个B文件里的第一个include宏。

能间接引用A头文件也可以：可根据报错信息里的符号，分析同Module其他引用此符号的文件是如何include的，总之include的代码正斜杠/越少越好。

新增include的行的限制：每行不要包括反斜杠\；正斜杠/的数量最多不要超过3个，可以没有。优先参考B文件的同Module内的cpp/h引用方式; 同Module内如果多处引用A，则优先参考正斜杠/最少的include处。

p4修改描述的限制: 开头必须是：[@dozhang]
结尾（里面$开头是当前流水线变量，注意必须替换为实际Value）是: https://devops.woa.com/console/pipeline/${{ci.project_id}}/${{ci.pipeline_id}}/detail/${{ci.build_id}}/executeDetail

如果需要添加注释，注释的限制是：Engine目录的代码， 用 maple @dozhang；其他目录的代码，则用@dozhang。

编译Error修复后，通过p4命令行（参考下面的模板A）新建一个Pending的ChangeList，简称CL，这个CL号要作为本插件的输出变量，输出的文件在工作目录的`pending_cl.txt`, 格式是纯数字, 不要有任何空格。

模板A Begin
@echo off

> cl.txt echo Change: new
>> cl.txt echo.
>> cl.txt echo Description:
>> cl.txt echo   <替换为：你的修改描述>

for /f "tokens=2" %%C in ('p4 change -i ^< cl.txt') do set CL=%%C

del cl.txt

p4 edit -c %CL% <替换为你修改的cpp文件路径>

echo %CL% > pending_cl.txt

echo File checked out in changelist %CL%

模板A End