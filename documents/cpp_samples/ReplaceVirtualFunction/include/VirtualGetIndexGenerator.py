
with open('./VirtualGetIndex.h', 'w') as f:
    f.write("#pragma once\n" )
    f.write("#define VirtualGetIndexBody \\\n" )
    for i in range(1024):
        f.write("virtual int Get%s() {return %s; } \\\n" % (i, i))
