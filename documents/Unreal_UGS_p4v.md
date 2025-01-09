# UnrealGameSync是如何实现免密连接P4V的？


## 背景

UnrealGameSync简称UGS

P4V是Perforce的图形化客户端

当你P4v处于已登录状态时，再打开UGS时，UGS会自动连接P4V，无需再次登录

UGS免登录的底层机制是怎样实现的呢？本文就是要探究这个问题，弄明白后可以帮助我们更好开发p4v相关的自动化工具, 满足好奇心倒是其次

- 让你的工具无需任何配置即可连接P4 Server, 
- 让你的工具能像UGS一样免登录即可连接P4 Server

## 先不考虑UGS，p4v已登录的情况下，单纯用p4.exe如何连接P4 Server呢

最传统的方法：p4v的File菜单栏，有一个"Open Command Prompt Here"的选项，点击后会打开一个cmd窗口，此cmd就连接到了server，然后你可以执行一些`p4 `命令

使用`p4 set`命令可以查看当前的p4属性设置

通过手动测试，我们不从p4v启动cmd，而是从windows操作系统启动一个cmd, 只要P4PORT、P4USER、P4CLIENT三个环境变量设置正确，也可以连接到P4 Server

那么这个问题就演变成了，UGS是如何读取这三个变量的

## P4PORT、P4USER的读取

P4PORT就是服务器ip和port， 

P4USER就是p4用户名

两者存储在注册表中：计算机\HKEY_CURRENT_USER\Software\Epic Games\UnrealGameSync

注册表打开方式：Win+R -> regedit

各种编程语言都可以方便地读取注册表，比如python的winreg模块

我是怎么知道的呢？阅读UGS的源码: `UnrealGameSync\GlobalSettings.cs`文件中的`ReadGlobalPerforceSettings`函数

## P4CLIENT的获取

P4CLIENT就是UGS当前的p4 workspace

P4CLIENT的获取方式是通过读取: `C:\Users\<Username>\AppData\Local\UnrealGameSync\UnrealGameSync.ini`

UGS.ini里General.OpenProjects.ClientPath字段就包含了P4CLIENT

UGS.ini是个非常有用的文件，还有很多其他非常有用的字段，本文不展开讨论，例如: UGS当前ChangeNumber, SyncResult(是否成功Sync), UGS工程的路径

注意：并不是所有人UGS.ini都叫UnrealGameSync.ini, 如果有人安装过2个版本的UGS，那么UGS.ini就会变成UnrealGameSyncV2.ini

所以要找最新的UGS.ini，可以通过遍历`C:\Users\<Username>\AppData\Local\UnrealGameSync`目录下的文件来判断, 下面是python代码示例

```python
UGSIniDirPathInHome = r"AppData\Local\UnrealGameSync"
UGSFilePrefix = "UnrealGameSync"
UGSFileEnd = ".ini"
DefaultUGSIni = "UnrealGameSync.ini"
def FindUGSIni(Home):
    ini_dir = os.path.join(Home, UGSIniDirPathInHome)
    selected_file = DefaultUGSIni
    if os.path.isdir(ini_dir):
        latestTime = 0
        for file in os.listdir(ini_dir):
            cur_path = os.path.join(ini_dir, file)
            if file.startswith(UGSFilePrefix) and file.endswith(UGSFileEnd) and os.path.isfile(cur_path):
                file_ver = file[len(UGSFilePrefix): -len(UGSFileEnd)]
                if len(file_ver) == 0 or (file_ver[0] == "V" and file_ver[1:].isdigit()):
                    ini_time = os.path.getmtime(cur_path)
                    if ini_time > latestTime:
                        latestTime = ini_time
                        selected_file = file
        print("Selected UGS.ini: %s" % selected_file)
    return os.path.join(ini_dir, selected_file), selected_file
    ```

## UGS是如何下载Precompiled Binaries

UGS源码工程: `Engine\Source\Programs\UnrealGameSync\UnrealGameSync.sln`

函数: PerforceArchive::EnumerateAsync, 文件: ArchiveInfo.cs

读取的文件：ProjectDir/Build/UnrealGameSync.ini

读取的字段: ZippedBinariesPath

## 总结

工具每少一项配置，就多一份用户体验

我们开发p4相关工具，无需用户(美术/策划/QA)任何配置，也可以像UGS这样直接读取P4PORT、P4USER、P4CLIENT, 然后免密连接到P4 Server

从而让你的工具看起来更智能，用起来更简单
