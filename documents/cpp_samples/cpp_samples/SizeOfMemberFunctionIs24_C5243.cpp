#include "SizeOfMemberFunctionIs24_C5243.h"
#include <iostream>
#include <functional>

bool TestClass::NeedsUpdate() {
	return true;
}

void TestMemberFunctionSize() {
	
	std::cout << sizeof(&TestClass::NeedsUpdate) << std::endl;

	// the correct way: Use std::function to Repalce QSMemberFunc
	typedef std::function<bool(TestClass*)> QSMemberFunc1;
	QSMemberFunc1 func1;
	func1 = [](TestClass* Obj) {
		return Obj->NeedsUpdate();
	};
}