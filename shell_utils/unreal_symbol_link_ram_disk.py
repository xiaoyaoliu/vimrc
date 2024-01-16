
import hashlib
import os
import shutil
import time
from datetime import datetime
from urllib import request
import multiprocessing
import subprocess
import filecmp
from pathlib import Path

EngineDir = "../Engine"
ProjectDir = "./"
# 之前统计的最多也就5层，这里设置8层，应该够用了
DllMaxDepth = 8
MemCacheDir = r"Q:\Cache\Projects"
NoDllDirs = set(["Intermediate", "Source", "Content", ".git", "Resources", "Config", "Shaders", "ThirdParty"])


def FindDllInWin64(win64_dir, withDebug, depth):
    dll_files = []
    for f in os.listdir(win64_dir):
        cur_path = os.path.join(win64_dir, f)
        if os.path.isdir(cur_path):
            # if depth + 1 < DllMaxDepth:
            # dll_files += FindDllInWin64(cur_path, withDebug, depth + 1)
            continue
        if not withDebug and f.endswith("Win64-DebugGame.dll"):
            continue
        if not (f.startswith('UnrealEditor') or f.startswith('LyraEditor')):
            if Path(cur_path).is_symlink():
                os.remove(cur_path)
            continue
        if f.endswith(".dll") or f.endswith(".exe"):
            dll_files.append((f[:-4], cur_path))
    return dll_files

def FindEngineDlls(engineDir, dirName, depth, withDebug):
    if dirName == 'Binaries':
        win64_dir = os.path.join(engineDir, 'Win64')
        # if os.path.isdir(win64_dir) or Path(win64_dir).is_symlink():
        if os.path.isdir(win64_dir):
            return FindDllInWin64(win64_dir, withDebug, depth)
        return []
    if depth >= DllMaxDepth:
        return []
    dll_files = []
    counter = 0
    for f in os.listdir(engineDir):
        cur_path = os.path.join(engineDir, f)
        # 剪枝加速: 干掉一些常用的目录
        if os.path.isdir(cur_path) and f not in NoDllDirs:
            dll_files += FindEngineDlls(cur_path, f, depth+1, withDebug)
            counter += 0
            continue
    # if counter == 0:
        # print(engineDir)
    return dll_files

def UnlinkSingleFile(sourcePath, cacheDir):
    if Path(sourcePath).is_symlink():
        os.remove(sourcePath)
        targetPath = os.path.join(cacheDir, os.path.basename(sourcePath))
        if os.path.isfile(targetPath):
            shutil.copy2(targetPath, sourcePath)


def LinkSingleFile(sourcePath, cacheDir):
    if not Path(sourcePath).is_symlink():
        targetPath = os.path.join(cacheDir, os.path.basename(sourcePath))
        if os.path.isfile(sourcePath):
            shutil.copy2(sourcePath, targetPath)
            os.remove(sourcePath)
        command = 'mklink "%s" "%s"' % (sourcePath, targetPath)
        proc = subprocess.Popen(command, stdout=subprocess.PIPE, stderr=subprocess.PIPE, shell=True)
        exit_code = proc.wait()
        if exit_code != 0:
            print("[%s]: %s" %( exit_code, command))


def LinkMemoryDisk():
    engineDlls = []
    engineDlls += FindEngineDlls(os.path.join(EngineDir, 'Plugins'), 'Plugins', 0, False)
    engineDlls += FindEngineDlls(os.path.join(ProjectDir, 'Plugins'), 'Plugins', 0, True)
    engineDlls += FindEngineDlls(os.path.join(ProjectDir, 'Binaries'), 'Binaries', 0, False)
    for dllName, dllPath in engineDlls:
        win64dir = os.path.dirname(dllPath)
        cacheDir = os.path.join(MemCacheDir, win64dir)
        sourcePath = os.path.abspath(dllPath)
        if not os.path.isdir(cacheDir):
            os.makedirs(cacheDir)
        UnlinkSingleFile(sourcePath, cacheDir)
        pdbPath = sourcePath.replace('.dll', '.pdb')
        LinkSingleFile(pdbPath, cacheDir)
    time.sleep(2.0)

if __name__=="__main__":
    try:
        LinkMemoryDisk()
    except Exception as e:
        import traceback
        traceback.print_exc()
        os.system("Pause")
