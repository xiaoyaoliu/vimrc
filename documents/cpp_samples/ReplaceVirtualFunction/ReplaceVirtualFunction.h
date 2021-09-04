#include "VirtualGetIndex.h"

template <class T, typename F>
int VTableIndex(F f)
{
	static struct VTableCounter
	{
		VirtualGetIndexBody
			// ... more ...
	} vt;

	T* t = reinterpret_cast<T*>(&vt);

	typedef int (T::*GetIndex)();
	GetIndex getIndex = (GetIndex)f;
	return (t->*getIndex)();
}

void DoMemReplace(size_t* VirtualFunctionTable, int index, size_t new_func);


template <class T, typename F>
void ReplaceVirtualFunction(T *obj, F f, size_t new_func)
{
	// address of virtual function table
	size_t vtfAddress = *(size_t*)obj; 
	// virtual table ptr
	size_t* pVirtualFunctionTable = (size_t*)vtfAddress;
	const int func_index = VTableIndex<T>(f);
	DoMemReplace(pVirtualFunctionTable, func_index, new_func);
}

// test funciton
void TestVirtualFunctionReplaceMain();