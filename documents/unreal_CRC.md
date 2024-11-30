
# Unreal的CrashReportClient的部署与定制开发

CrashReportClient就是Unreal的Crash报告工具，在UnrealEngine里简称CRC，本文主要介绍一些CRC的定制开发思路

## 背景

CRC的官方文档：https://dev.epicgames.com/documentation/en-us/unreal-engine/crash-reporting-in-unreal-engine

CRC就是当你的UnrealEditor，或者你发布的Game, 发生Crash时，会弹出的一个Crash报告窗口。

本文提到的部署、代码、函数，主要基于Unreal5.3

用CRC的最大好处就是当你的非程序员同事发生Crash，只需要发送一张CRC截图给你, 你就可以知道Crash的原因，提高Crash的处理效率

本文也会介绍如何利用CRC，将Crash线程的堆栈信息上传到收集统计网站, 尤其是FullCrashDump的堆栈

## CRC的部署

1. 大部分Unreal项目都不是直接使用公办引擎进行开发
2. 很多Unreal项目负责打包的程序员只考虑Game是否能跑起来，并没有部署CRC

本节主要介绍下如何才能让CRC跑起来: 无论是UnrealEditor.exe, 还是XXGame-Test.exe, 抑或是XXGame-Shipping.exe

### UnrealEditor目录的CRC部署

只要UnrealEditor.exe同目录存在`CrashReportClientEditor.exe`即可: `Engine\Binaries\Win64\CrashReportClientEditor.exe`

CRCEditor生成方法：
- 打开UE4/5.sln，编译模式选Shipping，VS里找到Programs/CrashReportClientEditor，右键生成即可
- 打包机的话，可以用下列指令生成后提交即可
```shell
.\Engine\Build\BatchFiles\Build.bat CrashReportClientEditor Win64 Shipping -WaitMutex -FromMsBuild
```

### 游戏Test包或者Shipping包的CRC部署

游戏的Test包或Shipping包的CRC部署方法是相同的，所以一起介绍

Test包主要需要`CrashReportClient.exe` , CRC才可以正常工作：
- File: `Engine\Binaries\Win64\CrashReportClient.exe`

但是CRC.exe有30个左右的依赖资源，要确保一起部署到Test包, 至少依赖如下资源：
- 6文件: Engine\Content\Internationalization\icudt64l\brkitr\char.brk, line_cj.brk, root.res, word.brk, zh.res, en.res
- 2文件: Engine\Content\Internationalization\icudt64l\curr\pool.res, root.res
- 4文件: Engine\Content\Internationalization\icudt64l\cnvalias.icu, pool.res, zh.res, en.res
- 1文件: `Engine\Content\Slate\Checkerboard.png`
- 2个字体文件：Engine\Content\Slate\Fonts\Roboto-Regular.ttf; Engine\Content\SlateDebug\Fonts\LastResort.ttf
- 目录：Engine\Shaders\StandaloneRenderer\D3D

下面文件是可选的文件(Optional):  
- CRC右上角3个按钮的图标：Engine\Content\Slate\Starship\CoreWidgets\Window
- CRC左上角的Unreal图标：Engine\Content\Slate\Starship\Common\unreal-small.svg
- CRC左下方协议的CheckBox：Engine\Content\Slate\Starship\CoreWidgets\CheckBox
- Engine\Content\Internationalization\icudt64l\zh_CN.res


上面的CRC依赖项只是经验总结，如果您的项目Crash后无法启动CRC，那么可以全局搜一下: `CrashReportClient.log`

通常log文件位于：C:\Users\<UserName>\AppData\Local\CrashReportClient\Saved\Logs\CrashReportClient.log

- 如果log文件不存在，那么说明Crash后，你压根就没有尝试启动CRC, 需要到Unreal代码里找原因
- 如果log文件存在，那么里面会有CRC启动时的详细信息，会告诉你缺少哪些资源

### 部署过程中的调试技巧


部署CRC的过程可能不是那么一帆风顺，很可能需要Debug, 尤其是Test包的部署。

启动CRC的代码基本都在：`Engine\Source\Runtime\Core\Private\Windows\WindowsPlatformCrashContext.cpp`

CRCEditor是随着UnrealEditor进程一起启动的，所以你启动UnrealEditor后，用任务管理器观察下有没有CRCEditor进程即可: 原理见函数`LaunchCrashReportClient`

CRC.exe是在Test包发生Crash后才启动的，具体的BreakPoint位置在函数`ReportCrashUsingCrashReportClient`里搜`CreateCrashReportClientPath`

如果Test包发生Crash后，却没有弹出CRC窗口，那么你就要先确保函数`ReportCrashUsingCrashReportClient`是否跑到了你的BreakPoint

但是，我碰到一个问题：Test包加上-fullcrashdump启动后闪退，在Unreal Handle Crash线程跑到创建CRC进程的那行代码时候又Crash了，导致CRC没弹出

```cpp
        // 在Crash目录(dmp文件所在目录，通常在Saved\Crashes里的一个子目录)生成CRCCommand.txt文件，内容是CRC的启动命令
        FString CrashReporterClientFullPath = FPaths::ConvertRelativePathToFull(CrashReporterClientPath);
        FString CRCCommandFilePath = FPaths::Combine(*CrashFolderAbsolute, TEXT("CRCCommand.txt"));

        FFileHelper::SaveStringToFile(FString::Printf(TEXT("%s %s"), *CrashReporterClientFullPath, *CrashReportClientArguments), *CRCCommandFilePath);
        // FullCrashDump时候，这行可能会Crash了
        bCrashReporterRan = FPlatformProcess::CreateProc(*CrashReporterClientFullPath, *CrashReportClientArguments, true, false, false, NULL, 0, NULL, NULL).IsValid();
        if (bCrashReporterRan)
        {
            // CRC启动成功后，则删除CRCCommand.txt文件
            IPlatformFile& PlatformFile = FPlatformFileManager::Get().GetPlatformFile();

            // Check if the file exists
            if (PlatformFile.FileExists(*CRCCommandFilePath))
            {
                // Attempt to delete the file
                PlatformFile.DeleteFile(*CRCCommandFilePath);
            }
        }
```

- 于是我加上了如上的代码，启动CRC之前先生成CRCCommand.txt文件，然后再启动CRC.exe，如果CRC启动Crash，那么dmp所在目录就会多一个CRCCommand.txt文件
- 我们有一个python写的类似游戏助手进程，里面加了一个逻辑: 如果dmp目录有CRCCommand.txt文件，那么读取CRCCommand.txt文件来执行CRC.exe，然后删除CRCCommand.txt文件.
- 这样实现了Test包即便是FullCrashDump时候CRC.exe也能稳定成功启动

## CRC的一些定制开发思路

### CRC的调试方法
由于只有CRCEditor是跟随UnrealEditor一起启动，所以日常定制开发CRC，都是按照如下方法调试代码（加BreakPoint）:
1. 启动UnrealEditor进程
2. 在VS里Attach到CrashReportClientEditor进程

对于，CRC.exe来说, 很难attach成功，基本全靠打log，看CrashReportClient.log, 前文已经提过，不再赘述
- 虽然Unreal给Test包提供了一个`-waitforattachcrc`参数，但是我试了下，没成功. 可能年久失修，所以还是老老实实打log吧

所以，日常分析CRC的代码，基本都是在CRCEditor里进行的

### 看到带行号的完整堆栈，而不是只有ModuleName

一般非程序员(策划/美术/QA)的UnrealEditor Crash后，CRC会弹出一个Crash报告窗口，里面有一堆ModuleName，但是没有行号和文件名，这样对于程序员来说，定位Crash点就很困难

没有行号和文件名的主要原因，就是因为他们本地没有调试符号，也就是所有Module对应的pdb

所以，我们可以在CRC里加一些代码，让CRC在Crash时，自动将Crash线程涉及到的所有Module对应的pdb文件从Symbol Server上下载下来，然后在Crash报告窗口里显示完整行号和文件名

Q1: 有人可能会质疑，你下载pdb到本地，pdb文件不是很大吗，会不会影响CRC的启动速度？

A1: 因为只下载Crash线程的所有Module的pdb，实测Crash线程的pdb数量一般不会超过10个，`DownloadEnginePdbs.py`是我自研的多进程下载pdb工具，通常20秒左右就下载完了

Q2: pdb文件都很大，如果策划经常Crash，你下载的pdb会不会把硬盘撑爆？

A2: 我自研的`DownloadEnginePdbs.py`工具，会自动清理掉非本次Crash需要的pdb文件，所以不用担心硬盘爆炸。也就是策划本地常年最多也就10个pdb文件

Q3: `DownloadEnginePdbs.py`工具会公开吗？

A3: 不会，本文主要介绍思路，并不是所有都开源

代码入口主要在: 文件`CrashReportClientApp.cpp` CollectErrorReport函数里加一下

```cpp

    TArray<FString> CrashCallStackModules;
	for (uint32 ThreadIdx = 0; ThreadIdx < SharedCrashContext.NumThreads; ThreadIdx++)
	{
        if (ThreadId == SharedCrashContext.CrashingThreadId)
		{
#if PLATFORM_WINDOWS
			TArray<FCrashStackFrame> CrashCallStack;
			CrashContext.GetPortableCallStack(
				StackFrameCursor, StackFrameCount,
				CrashCallStack
			);
			for(const FCrashStackFrame& StackFrame: CrashCallStack)
			{
				CrashCallStackModules.AddUnique(StackFrame.ModuleName);
			}
#endif
        }
    }
#if PLATFORM_WINDOWS
	if (!CrashCallStackModules.IsEmpty() && CrashContext.GetType() != ECrashContextType::Stall && CrashContext.GetType() != ECrashContextType::Ensure && CrashContext.GetType() != ECrashContextType::Hang && CrashContext.GetType() < ECrashContextType::Max)
	{
		FString PyExe = TEXT("..\\..\\..\\Engine\\Binaries\\ThirdParty\\Python3\\Win64\\python.exe");
		PyExe = FPaths::ConvertRelativePathToFull(PyExe);
		if (FPaths::FileExists(PyExe))
		{
            // 调用外部python代码下载pdb
			FString DownloadPdbsPy = TEXT("DownloadEnginePdbs.py");
			DownloadPdbsPy = FPaths::ConvertRelativePathToFull(DownloadPdbsPy);
			if (FPaths::FileExists(DownloadPdbsPy))
			{
				FString PyArgs = FString::Join(CrashCallStackModules, TEXT("#"));

				int32	ReturnCode = 0;
				FString Results;
				FString Errors;
				TArray<FString> Args = { DownloadPdbsPy, TEXT("--modules"), PyArgs };
				FString FullCommand = FString::Join(Args, TEXT(" "));
				FPlatformProcess::ExecProcess(*PyExe, *FullCommand, &ReturnCode, &Results, &Errors);

				if (ReturnCode != 0)
				{
					UE_LOG(CrashReportClientLog, Warning, TEXT("DownloadEnginePdbs: %s"), *Errors);
				}
			}

		}

	}
#endif
```

### 利用CRC自动将Crash信息发送到自家的收集网站

Crash统计网站, 也是Crash收集网站

传统的办法一般是客户端上传dmp文件到收集网站，打包机负责上传调试符号（例如pdb）到收集网站, 然后收集网站会自行解析dmp文件，生成CallStack等信息给开发者

上面办法目前有缺点:
1. Unreal的一些Assert类型的dmp，解析出来的却是一些windows里的dll，完全看不到有用的CallStack
2. 网站可能存在bug，即便是解析出来了CallStack，却只有一行
3. 一般的Crash收集网站，都不支持上传FullCrashDump: 因为FullCrashDump太大了，少则几个G，多则几十个G

CRC就可以解决如上痛点，既然我们让CRC显示了完整的堆栈信息，所以我们就可以直接将这些CallStack作为字符串直接上传 到收集网站

```cpp
void FCrashReportClient::UploadCrashToServer(){
    // 你需要上传的信息基本都在这个对象里: FPrimaryCrashProperties::Get(), 
    // 具体上传哪些信息，你自己在这里加个BreakPoint看下即可
    FPrimaryCrashProperties CrashProps = FPrimaryCrashProperties::Get()
    ......
}
void FCrashReportClient::FinalizeDiagnoseReportWorker()
{
	FormattedDiagnosticText = FCrashReportUtil::FormatDiagnosticText( DiagnosticText );

    // 新加一个函数UploadCrashToServer, 里面就是上传Crash信息到自家的收集网站
	UploadCrashToServer();
}
```

利用CRC收集Crash信息的优点:
1. FullCrashDump也会启动CRC，所以FullCrashDump的堆栈也能通过CRC上传到统计网站
2. 堆栈中可以显示Unreal中check代码导致assert信息, 且上传的堆栈是完整的
