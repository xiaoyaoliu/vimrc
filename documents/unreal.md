

## 自编译的unreal

自编译的unreal会产生一个uuid在注册表中，详情见FDesktopPlatformWindows::EnumerateEngineInstallations

unreal版本注册表路径: HKEY_CURRENT_USER/SOFTWARE\\Epic Games\\Unreal Engine\\Builds

## UnrealBuildTool

Unreal所有的工程，都是通过UnrealBuildTool来编译的。

Q: generated.h头文件是在编译过程中产生，那么UBT是如何产生这个头文件的呢？
A: Main(UnrealBuildTool.cs) -> BuildMode::Execute(BuildMode.cs) -> BuildMode::CreateMakefile -> ExternalExecution.ExecuteHeaderToolIfNecessary

可以看出UBT最终是调用UnrealHeaderTool来完成generated头文件生成的。

Q2: Copy了一个UnrealHeaderTool工程，仅仅是改了下工程名字（比如叫NewHeaderTool），就Link Error：

```cpp
Module.CoreUObject.gen.cpp.obj : error LNK2005: "class UClass * __cdecl Z_Construct_UClass_UObject(void)" (?Z_Construct_UClass_UObject@@YAPEAVUClass@@XZ) already defined in Module.CoreUObject.3_of_8.cpp.obj
Module.CoreUObject.gen.cpp.obj : error LNK2005: "private: static class UClass * __cdecl UObject::GetPrivateStaticClass(void)" (?GetPrivateStaticClass@UObject@@CAPEAVUClass@@XZ) already defined in Module.CoreUObject.3_of_8.cpp.obj
```
A2: 因为UE的工程都是用UnrealBuildTool编译的，但是UBT工程里有针对UnrealHeaderTool的特殊逻辑(HardCode), 所以你改名字后就编译不过了，解决方法如下:
```cpp
//文件: UEBuildTarget.cs
    private void SetupGlobalEnvironment(UEToolChain ToolChain, CppCompileEnvironment GlobalCompileEnvironment, LinkEnvironment GlobalLinkEnvironment)
	{
			UEBuildPlatform BuildPlatform = UEBuildPlatform.GetBuildPlatform(Platform);

			ToolChain.SetUpGlobalEnvironment(Rules);

			// @Hack: This to prevent UHT from listing CoreUObject.init.gen.cpp as its dependency.
			// We flag the compile environment when we build UHT so that we don't need to check
			// this for each file when generating their dependencies.
			//GlobalCompileEnvironment.bHackHeaderGenerator = (AppName == "UnrealHeaderTool");
            //NewHeaderTool 就是新的HeaderTool的名称！
			GlobalCompileEnvironment.bHackHeaderGenerator = (AppName == "UnrealHeaderTool") || (AppName == "NewHeaderTool");
    }
```

Q3: UHT工程里，到底哪里是用于解析UStruct头文件的逻辑呢？

A3: INT32_MAIN_INT32_ARGC_TCHAR_ARGV(UnrealHeaderToolMain.cpp) -> UnrealHeaderTool_Main(CodeGenerator.cpp) -> FHeaderParser::ParseAllHeadersInside -> FHeaderParser::ParseHeader -> CompileStatement -> CompileDeclaration -> CompileStructDeclaration
