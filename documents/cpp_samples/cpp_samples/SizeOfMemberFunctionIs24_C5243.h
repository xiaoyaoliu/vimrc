#pragma once

class TestClass;
typedef void(TestClass::* QSMemberFunc)();


class B {
public:
	B():func(nullptr){}
	//https://github.com/MicrosoftDocs/cpp-docs/blob/master/docs/error-messages/compiler-warnings/c5243.md
	QSMemberFunc func;
};

class TestClass
{
public:
	bool NeedsUpdate();
};


void TestMemberFunctionSize();