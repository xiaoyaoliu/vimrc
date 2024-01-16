## Symbol Server

打包机(build machine) 通常会将pdb上传到Symbol Server

Symbol Server看起来就是一个HTTP File Server: https://en.wikipedia.org/wiki/HTTP_File_Server

例如，一个典型的Symbol Server上的Url: http://your.server.ip.0/UnrealEditor-RenderCore.pdb/06BEA9E1737244C7A1C90AD8FED6E7091/UnrealEditor-RenderCore.pd_

使用者，直接在Visual studio中配置一下Symbol Server的地址(Tools -> Options -> Debugging -> Symbols)

用VS启动项目后就可以按需（VS 判断你用了哪些DLL）拉取和本地DLL匹配的PDB文件进行调试

调试包括：加断点、看Crash Traceback、看变量等。

## pd_格式的文件

pd_格式的文件通常是压缩过的pdb（Program Database）文件。pdb文件是Microsoft在Windows平台上用于存储程序调试信息的一种文件格式。

pd_解压为pdb的命令如下:
```sh
expand -r UnrealEditor-RenderCore.pd_
```

## 中间的06BEA9E1737244C7A1C90AD8FED6E7091是哈希值吗？

不是Hash！这是DLL的Guid

因为同一个DLL，也有很多版本，每个版本都有一个对应的GUID以查找对应的PDB

计算DLL Guid的方法: https://gist.github.com/Manouchehri/98dbb75e226e6cc962b989caef38b399

python示例如下：

```python
import pefile
import struct
# dll_path是DLL文件的路径
def get_guid(dll_path):
    # https://gist.github.com/Manouchehri/98dbb75e226e6cc962b989caef38b399 
    #ugly code, isn't it ?
    try:
        dll = pefile.PE(dll_path)
        rva = dll.DIRECTORY_ENTRY_DEBUG[0].struct.AddressOfRawData
        tmp = ''
        tmp += '%0.*X' % (8, dll.get_dword_at_rva(rva+4))
        tmp += '%0.*X' % (4, dll.get_word_at_rva(rva+4+4))
        tmp += '%0.*X' % (4, dll.get_word_at_rva(rva+4+4+2))
        x = dll.get_word_at_rva(rva+4+4+2+2)
        tmp += '%0.*X' % (4, struct.unpack('<H',struct.pack('>H',x))[0])
        x = dll.get_word_at_rva(rva+4+4+2+2+2)
        tmp += '%0.*X' % (4, struct.unpack('<H',struct.pack('>H',x))[0])
        x = dll.get_word_at_rva(rva+4+4+2+2+2+2)
        tmp += '%0.*X' % (4, struct.unpack('<H',struct.pack('>H',x))[0])
        x = dll.get_word_at_rva(rva+4+4+2+2+2+2+2)
        tmp += '%0.*X' % (4, struct.unpack('<H',struct.pack('>H',x))[0])
        tmp += '%0.*X' % (1, dll.get_word_at_rva(rva+4+4+2+2+2+2+2+2))
    except AttributeError as e:
        print('Error appends during %s parsing' % dll_path)
        print(e)
        return None
    return tmp.upper()

```
## 下载DLL对应的PDB的官方方法

symbol server: https://learn.microsoft.com/zh-cn/windows/win32/dxtecharts/debugging-with-symbols?redirectedfrom=MSDN

```sh
"C:\Program Files (x86)\Windows Kits\8.1\Debuggers\x64\symchk.exe" X:\your\local\path\to\UnrealEditor-RenderCore.dll /s  Srv*C:\Users\YourName\AppData\Local\Temp\SymbolCache*http://your.symbol.server.ip /os /op
```

以上命令会从Servrer上查找UnrealEditor-RenderCore.dll对应的pdb，并下载到本地的目录: C:\Users\YourName\AppData\Local\Temp\SymbolCache

以上命令会输出匹配的pdb的fullpath；

如果添加一个重定向到一个文件的话，会输出空字符串，所以就无法用python来调用，因为看不到任何输出！


```sh
"C:\Program Files (x86)\Windows Kits\8.1\Debuggers\x64\symchk.exe" X:\your\local\path\to\UnrealEditor-RenderCore.dll /s  Srv*C:\Users\YourName\AppData\Local\Temp\SymbolCache*http://your.symbol.server.ip /os /op > C:\111.txt
```

如果本地之前从未下载过这个UnrealEditor-RenderCore.pdb，那么111.txt将是空文件

如果用python下载pdb的话，建议直接构造Url，使用HTTP协议下载。
