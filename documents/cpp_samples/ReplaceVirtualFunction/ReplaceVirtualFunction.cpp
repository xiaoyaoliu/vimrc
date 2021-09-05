#include "ReplaceVirtualFunction.h"
#include <iostream>
#include <windows.h>
#include <unordered_map>
#include <string>
#include <assert.h>
using namespace std;

struct OriginVirtualInfo
{
	size_t* mVirtualFunctionTable;
	int mIndex;
	size_t mOriginFuncMemAddr;
};
typedef std::unordered_map<std::string, OriginVirtualInfo> FuncTableType;

FuncTableType NewFuncNameToOldFuncs;

static const int PTR_BYTES = sizeof(size_t);

void __DoMemReplace(size_t* virtualFunctionTable, int index, size_t newFunc, const char* new_funcname)
{
#if _DEBUG
	cout << "vt addr " << hex << (size_t)virtualFunctionTable << endl;
	cout << "vt func " << hex << newFunc << "\r\nold func:" << hex << virtualFunctionTable[index] << "\t" << index << endl;
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
	
	DWORD old;
	VirtualProtect(virtualFunctionTable, PTR_BYTES, PAGE_READWRITE, &old);
	virtualFunctionTable[index] = newFunc;
	VirtualProtect(virtualFunctionTable, PTR_BYTES, old, &old);

	
	
}


size_t __PauseReplace(const char* new_funcname)
{
	size_t func = 0;
	FuncTableType::iterator origInfos = NewFuncNameToOldFuncs.find(new_funcname);
	if (origInfos == NewFuncNameToOldFuncs.end()) {
		return func;
	}
	OriginVirtualInfo& info = origInfos->second;
	func = info.mVirtualFunctionTable[info.mIndex];
	DWORD old;
	VirtualProtect(info.mVirtualFunctionTable, PTR_BYTES, PAGE_READWRITE, &old);
	info.mVirtualFunctionTable[info.mIndex] = info.mOriginFuncMemAddr;
	VirtualProtect(info.mVirtualFunctionTable, PTR_BYTES, old, &old);
	return func;
}

void __ResumeReplace(const char* new_funcname, size_t new_func)
{
	FuncTableType::iterator origInfos = NewFuncNameToOldFuncs.find(new_funcname);
	if (origInfos == NewFuncNameToOldFuncs.end()) {
		return;
	}
	OriginVirtualInfo& info = origInfos->second;
	DWORD old;
	VirtualProtect(info.mVirtualFunctionTable, PTR_BYTES, PAGE_READWRITE, &old);
	info.mVirtualFunctionTable[info.mIndex] = new_func;
	VirtualProtect(info.mVirtualFunctionTable, PTR_BYTES, old, &old);
}





#pragma region TestCode

void chengedPrintf()
{
	cout << "Member Function Changed " << endl;
}

class A {
public:
	virtual void fun() {
		std::cout << "A::fun\n";
	}
	virtual void fun2() {
		std::cout << "A::fun2\n";
	}
};
class B1 :public A {
public:
	void fun() {
		std::cout << "B1::fun\n";
	}
	void fun2() {
		std::cout << "B1::fun2\n";
	}
};
class B2 :public A {
public:
	void fun() {
		std::cout << "B2::fun\n";
	}
};


class ReplaceA
{
public:
	virtual void OverrideFun2()
	{
		auto a = (A*)this;
		SuperCall(__FUNCTION__, a->fun2());
		cout << "Member Function Changed and can use this now" << endl << endl;
	}

};


void TestVirtualFunctionReplaceMain()
{

	A* pObj[3] = {
	   new B1,
	   new B1,
	   new B2
	};

	//ReplaceVirtualFunction(pObj[0], &B1::fun2, (uint64_t)chengedPrintf);
	ReplaceA replObj;
	size_t oldfun = ReplaceVirtualWithMember(pObj[0], B1::fun2, &replObj, ReplaceA::OverrideFun2);
	ReplaceVirtualWithFunction(pObj[2], A::fun2, chengedPrintf);

	for (A* pTmp : pObj) {
		pTmp->fun2();
	}
	
}


#pragma endregion