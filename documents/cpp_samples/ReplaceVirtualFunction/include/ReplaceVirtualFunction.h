#pragma once
#include "VirtualGetIndex.h"


// DLL export and import definitions
#define DLLEXPORT __declspec(dllexport)
#define DLLIMPORT __declspec(dllimport)

#ifdef DLL_EXPORT
#ifdef REPLACE_VIRTUAL_FUNCTION_EXPORT
#define REPLACE_VIRTUAL_FUNCTION_API DLLEXPORT
#else
#define REPLACE_VIRTUAL_FUNCTION_API DLLIMPORT
#endif
#else
#define REPLACE_VIRTUAL_FUNCTION_API
#endif


template <class T, typename F>
int __VTableIndex(F f)
{
	static struct VTableCounter
	{
		VirtualGetIndexBody
			// ... more ...
	} vt;

	T* t = reinterpret_cast<T*>(&vt);

	typedef int (T::*GetIndex)();
#pragma warning(push)
#pragma warning(disable: 4191)
	GetIndex getIndex = (GetIndex)f;
#pragma warning(pop)
	return (t->*getIndex)();
}

REPLACE_VIRTUAL_FUNCTION_API void __DoMemReplace(size_t* VirtualFunctionTable, int index, size_t new_func, const char* new_funcname);

REPLACE_VIRTUAL_FUNCTION_API size_t __PauseReplace(const char* new_funcname, bool deleteReplace);

REPLACE_VIRTUAL_FUNCTION_API void __ResumeReplace(const char* new_funcname, size_t new_func);

template <typename T, typename F>
size_t __ReplaceVirtualFunction(T *obj, F f, size_t new_func, const char* new_funcname)
{
	// address of virtual function table
	size_t vtfAddress = *(size_t*)obj; 
	// virtual table ptr
	size_t* pVirtualFunctionTable = (size_t*)vtfAddress;
	const int func_index = __VTableIndex<T>(f);
	size_t old_func = pVirtualFunctionTable[func_index];
	__DoMemReplace(pVirtualFunctionTable, func_index, new_func, new_funcname);
	return old_func;
}


template <typename TOld, typename FOld, typename TNew, typename FNew>
size_t __ReplaceVirtualWithMember(TOld* obj, FOld f, TNew *new_obj, FNew new_func, const char* new_funcname)
{
	// address of virtual function table
	size_t vtfAddress = *(size_t*)obj;
	// virtual table ptr
	size_t* pVirtualFunctionTable = (size_t*)vtfAddress;
	const int func_index = __VTableIndex<TOld>(f);

	const int new_func_index = __VTableIndex<TNew>(new_func);
	size_t* NewVirtualFunctionTable = (size_t*)*(size_t*)new_obj;
	size_t old_func = pVirtualFunctionTable[func_index];
	__DoMemReplace(pVirtualFunctionTable, func_index, NewVirtualFunctionTable[new_func_index], new_funcname);
	return old_func;
}

template <typename T, typename F>
T ForceTypeCast(F src)
{
	union 
	{
		T t;
		F f;
	} u;
	u.f = src;
	return u.t;
}


#define ReplaceVirtualWithVirtualMember(obj, f, new_obj, new_func) __ReplaceVirtualWithMember(obj, &f, new_obj, &new_func, #new_func);

#define ReplaceVirtualWithNonVirtualMember(obj, f, new_func) __ReplaceVirtualFunction(obj, &f, ForceTypeCast<size_t>(&new_func), #new_func);

#define ReplaceVirtualWithFunction(obj, f, new_func) __ReplaceVirtualFunction(obj, &f, (size_t)new_func, #new_func);

#define RecoverReplace(new_func)  __PauseReplace(#new_func, true);

#define SuperVirtualCall(callSupers) {auto __CUR_FUNC_ADDR = __PauseReplace(__FUNCTION__, false); \
callSupers; \
__ResumeReplace(__FUNCTION__, __CUR_FUNC_ADDR);	\
}




