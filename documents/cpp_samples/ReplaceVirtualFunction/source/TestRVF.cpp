#include "TestRVF.h"
#if _DEBUG
#include "ReplaceVirtualFunction.h"
#include <iostream>
#include <string>
using namespace std;




void changedVirtualFunc()
{
	cout << "Virtual Function Is Changed " << endl;
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
		SuperVirtualCall(a->fun2());
		cout << "Member Function Changed and can use this now" << endl << endl;
	}

};

#endif


void TestVirtualFunctionReplaceMain()
{
#if _DEBUG

	A* pObj[3] = {
	   new B1,
	   new B1,
	   new B2
	};

	//ReplaceVirtualFunction(pObj[0], &B1::fun2, (uint64_t)chengedPrintf);
	ReplaceA replObj;
	size_t oldfun = ReplaceVirtualWithMember(pObj[0], B1::fun2, &replObj, ReplaceA::OverrideFun2);
	ReplaceVirtualWithFunction(pObj[2], A::fun2, changedVirtualFunc);

	for (A* pTmp : pObj) {
		pTmp->fun2();
	}
#endif
	
}

