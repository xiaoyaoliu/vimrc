import hashlib
import os
import shutil

EngineDir = "../Engine"
ProjectDir = "./"

def md5(fname):
    hash_md5 = hashlib.md5()
    with open(fname, "rb") as f:
        chunk = f.read(8192)
        while chunk:
            hash_md5.update(chunk)
            chunk = f.read(8192)
    return hash_md5.hexdigest()

def FindSymbolCacheDir():
    home = os.path.expanduser("~")
    vs_config_dir = os.path.join(home, r"AppData\Local\Microsoft\VisualStudio")
    dir_map = {}
    for f in os.listdir(vs_config_dir):
        if '.' in f:
            the_key_str = f.split('.')[0]
            if the_key_str.isdigit():
                dir_map[int(the_key_str)] = f

    the_keys = dir_map.keys()
    the_keys.sort(reverse=True)
    keyword = 'name="SymbolCacheDir">'
    result = ""

    for one_key in the_keys:
        cur_vs_file = os.path.join(vs_config_dir, dir_map[one_key], "Settings/CurrentSettings.vssettings")
        if os.path.isfile(cur_vs_file):
            with open(cur_vs_file, 'r') as f:
                content = f.read()

                find_idx = content.find(keyword)
                if find_idx >= 0:
                    start_idx = find_idx + len(keyword)
                    end_idx = start_idx
                    while end_idx < len(content) and content[end_idx] != '<':
                        end_idx += 1
                    result = content[start_idx:end_idx].strip()
                    break
    return result


class PdbInfo(object):

    def __init__(self, inPath, inMd5):
        self.mPath = inPath
        self.mMd5 = inMd5
        self.mDllRefs = []

    mPath = ""
    mMd5 = ""
    mDllRefs = []



def PickBestPdbFile(symbolDir, pdbname):
    latestTime = 0
    latestPdb = ""
    for f in os.listdir(symbolDir):
        hash_dir = os.path.join(symbolDir, f)
        if os.path.isdir(hash_dir):
            for pdb_f in os.listdir(hash_dir):
                if pdb_f == pdbname:
                    pdb_path = os.path.join(hash_dir, pdb_f)
                    if os.path.isfile(pdb_path):
                        pdb_time = os.path.getmtime(pdb_path)
                        if pdb_time > latestTime:
                            latestTime = pdb_time
                            latestPdb = pdb_path
    return latestPdb

def BuildSymbols(symbolRootDir):
    assert(os.path.isdir(symbolRootDir))
    symbols_map = {}
    for f in os.listdir(symbolRootDir):
        if f.endswith('.pdb'):
            symbol_dir = os.path.join(symbolRootDir, f)
            if os.path.isdir(symbol_dir):
                symbol_key = f[:-4]
                latestPdb = PickBestPdbFile(symbol_dir, f)
                if os.path.isfile(latestPdb):
                    symbols_map[symbol_key] = PdbInfo(latestPdb, "")
                    # symbols_map[symbol_key] = PdbInfo(latestPdb, md5(latestPdb))
                    # print(latestPdb, symbols_map[symbol_key].mMd5)
    return symbols_map

def FindDllInWin64(win64_dir):
    dll_files = []
    for f in os.listdir(win64_dir):
        cur_path = os.path.join(win64_dir, f)
        if os.path.isdir(cur_path):
            dll_files += FindDllInWin64(cur_path)
            continue
        if f.endswith(".dll"):
            dll_files.append((f[:-4], cur_path))
    return dll_files

def FindEngineDlls(engineDir, dirName):
    if dirName == 'Binaries':
        win64_dir = os.path.join(engineDir, 'Win64')
        if os.path.isdir(win64_dir):
            return FindDllInWin64(win64_dir)
        return []
    dll_files = []
    for f in os.listdir(engineDir):
        cur_path = os.path.join(engineDir, f)
        if os.path.isdir(cur_path):
            dll_files += FindEngineDlls(cur_path, f)
            continue
    return dll_files


def CopySymbolsToEngineDir():
    symbolRootDir = FindSymbolCacheDir()
    if not symbolRootDir:
        print('[error] you should add Symbol Server for Visual studio firstly: Menu Tools -> Options -> Debugging -> Symbols -> + Your Symbol Server.')
        import webbrowser
        webbrowser.open(help_url)
        return
    symbols_map = BuildSymbols(symbolRootDir)
    engineDlls = FindEngineDlls(os.path.join(EngineDir, 'Binaries'), 'Binaries')
    engineDlls += FindEngineDlls(os.path.join(EngineDir, 'Plugins'), 'Plugins')
    engineDlls += FindEngineDlls(os.path.join(ProjectDir, 'Plugins'), 'Plugins')
    engineDlls.append(('UnrealEditor', os.path.join(EngineDir, 'Binaries/Win64/UnrealEditor.exe')))
    counter = total = len(engineDlls)
    for dll_key, dll_path in engineDlls:
        if dll_key in symbols_map:
            pdb_path = symbols_map[dll_key].mPath
            symbols_map[dll_key].mDllRefs.append(dll_path)
            dll_dir = os.path.dirname(dll_path)
            print("[Copy Pdb...] [%d / %d] %s To %s" % (total, counter, pdb_path[len(symbolRootDir):], dll_path[len(EngineDir):]))
            shutil.copy2(pdb_path, dll_dir)
        counter -= 1

    # Debug Check
    for key, val in symbols_map.iteritems():
        if len(val.mDllRefs) == 0:
            print("[Warning] not found dll: %s" % val.mPath[len(symbolRootDir):])

CopySymbolsToEngineDir()

