#include "ReplaceVirtualFunction.h"
#include <iostream>
#include <windows.h>
#include <unordered_map>
#include <string>
#include <assert.h>

struct OriginVirtualInfo
{
	size_t* mVirtualFunctionTable;
	int mIndex;
	size_t mOriginFuncMemAddr;
};
typedef std::unordered_map<std::string, OriginVirtualInfo> FuncTableType;

FuncTableType NewFuncNameToOldFuncs;



void __DoMemWrite(size_t* virtualFunctionTable, int index, size_t newFunc) {
	DWORD old;
	static const int PTR_BYTES = sizeof(size_t);
	VirtualProtect(virtualFunctionTable + index, PTR_BYTES, PAGE_READWRITE, &old);
	virtualFunctionTable[index] = newFunc;
	VirtualProtect(virtualFunctionTable + index, PTR_BYTES, old, &old);
}

void __DoMemReplace(size_t* virtualFunctionTable, int index, size_t newFunc, const char* new_funcname)
{
#if _DEBUG
	//cout << "vt addr " << hex << (size_t)virtualFunctionTable << endl;
	//cout << "vt func " << hex << newFunc << "\r\nold func:" << hex << virtualFunctionTable[index] << "\t" << index << endl;
#endif
	if (new_funcname != nullptr) {
		std::string newFuncName = new_funcname;
		assert(NewFuncNameToOldFuncs.find(newFuncName) == NewFuncNameToOldFuncs.end());
		OriginVirtualInfo info;
		{
			info.mVirtualFunctionTable = virtualFunctionTable;
			info.mIndex = index;
			info.mOriginFuncMemAddr = virtualFunctionTable[index];
		}
		NewFuncNameToOldFuncs.emplace(std::make_pair(newFuncName, info));
	}
	
	__DoMemWrite(virtualFunctionTable, index, newFunc);
}



size_t __PauseReplace(const char* new_funcname, bool deleteReplace)
{
	size_t func = 0;
	FuncTableType::iterator origInfos = NewFuncNameToOldFuncs.find(new_funcname);
	if (origInfos == NewFuncNameToOldFuncs.end()) {
		return func;
	}
	OriginVirtualInfo& info = origInfos->second;
	func = info.mVirtualFunctionTable[info.mIndex];
	__DoMemWrite(info.mVirtualFunctionTable, info.mIndex, info.mOriginFuncMemAddr);

	if (deleteReplace) {
		NewFuncNameToOldFuncs.erase(origInfos);
	}
	return func;
}

void __ResumeReplace(const char* new_funcname, size_t new_func)
{
	FuncTableType::iterator origInfos = NewFuncNameToOldFuncs.find(new_funcname);
	if (origInfos == NewFuncNameToOldFuncs.end()) {
		return;
	}
	OriginVirtualInfo& info = origInfos->second;
	__DoMemWrite(info.mVirtualFunctionTable, info.mIndex, new_func);
}
