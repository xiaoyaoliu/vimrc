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
