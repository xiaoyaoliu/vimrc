import subprocess
from os import path
import os

WORK_DIR = R"YourDllDir"
SYS_DIR = R"C:\Windows\System32"
SYS_DIR_LOW = R"C:\Windows\System32\downlevel"

def finddll(targetdll, res, curdll):
    dumpbin_dir = R"C:\Program Files\Microsoft Visual Studio\2022\Professional\VC\Tools\MSVC\14.16.27023\bin\HostX64\x64"
    curfulldll = path.join(WORK_DIR, curdll)
    if not path.isfile(curfulldll):
        # print(curdll)
        return
    subp = subprocess.Popen("cd %s && dumpbin /dependents %s" % (dumpbin_dir, curfulldll), shell=True, stdout=subprocess.PIPE)
    subprocess_return = subp.stdout.read()
    hasStarted = 0
    for line in  subprocess_return.splitlines():
        line = line.decode("utf-8").strip()
        if line.endswith("following dependencies:"):
            hasStarted = 1
            continue
        if not hasStarted:
            continue

        if targetdll.lower() == line.lower():
            print(res + "/" + curdll)
            return
        if line.endswith(".dll"):
            finddll(targetdll, res + "/" + curdll, line)


finddll("msvcp110.dll", "", "xxxx.exe")
