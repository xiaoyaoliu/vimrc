#include "ReplaceVirtualFunction.h"
#include <iostream>
#include <windows.h>
using namespace std;



void DoMemReplace(size_t* virtualFunctionTable, int index, size_t newFunc)
{
#if _DEBUG
	cout << "vt addr " << hex << (size_t)virtualFunctionTable << endl;
	cout << "vt func " << hex << newFunc << "\r\nold func:" << hex << virtualFunctionTable[index] << "\t" << index << endl;
#endif
	static const int PTR_BYTES = sizeof(size_t);
	DWORD old;
	VirtualProtect(virtualFunctionTable, PTR_BYTES, PAGE_READWRITE, &old);
	virtualFunctionTable[index] = newFunc;
	VirtualProtect(virtualFunctionTable, PTR_BYTES, old, &old);
	
}

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


void TestVirtualFunctionReplaceMain()
{

	A* pObj[3] = {
	   new B1,
	   new B1,
	   new B2
	};

	ReplaceVirtualFunction(pObj[0], &B1::fun2, (uint64_t)chengedPrintf);

	for (A* pTmp : pObj) {
		pTmp->fun2();
	}
	
}