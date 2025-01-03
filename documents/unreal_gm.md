## Unreal Command

unreal的Gm指令输入方式: 在编辑器下方状态栏有输入框(Enter Console Command)

command大多定义在: BaseInput.ini

### Animation

需要先启动游戏

打开动画Debug信息的GM: ShowDebug ANIMATION

由于动画树通常很大，占用过多屏幕空间，经常需要隐藏动画树: ShowDebugToggleSubCategory GRAPH

相关代码: AHUD::ShowDebug -> ACharacter::DisplayDebug -> UAnimInstance::DisplayDebug

Q: 如何查看第三方动画的Debug Info ?

A: 使用Unreal的官方调试器Rewind Debugger: 菜单栏 -> Tools -> Debug -> Rewind Debugger


### Camera

打开Camera Debug信息的GM: ShowDebug CAMERA

查看Camera Shake的gm: r.CameraShakeDebug = 1

### Audio Sound

官方文档: https://docs.unrealengine.com/5.0/en-US/audio-console-commands-in-unreal-engine/

运行时音效可视化gm: au.3dVisualize.Enabled = 1

### Tick分析

gm: dumpticks

### 查看一些默认关闭的log

gm指令: log log类型 log级别

以Montage的log为例

```cpp
// UAnimInstance::Montage_PlayInternal
UE_LOG(LogAnimMontage, Verbose, TEXT("Montage_Play: AnimMontage: %s,  (DesiredWeight:%0.2f, Weight:%0.2f)"),
				*NewInstance->Montage->GetName(), NewInstance->GetDesiredWeight(), NewInstance->GetWeight());
```

上面这个log系统默认是不显示的，开启办法: log LogAnimMontage Verbose 或 log LogAnimMontage All

log级别在ELogVerbosity中

``` cpp
namespace ELogVerbosity
{
	enum Type : uint8
	{
		/** Not used */
		NoLogging		= 0,

		/** Always prints a fatal error to console (and log file) and crashes (even if logging is disabled) */
		Fatal,

		/** 
		 * Prints an error to console (and log file). 
		 * Commandlets and the editor collect and report errors. Error messages result in commandlet failure.
		 */
		Error,

		/** 
		 * Prints a warning to console (and log file).
		 * Commandlets and the editor collect and report warnings. Warnings can be treated as an error.
		 */
		Warning,

		/** Prints a message to console (and log file) */
		Display,

		/** Prints a message to a log file (does not print to console) */
		Log,

		/** 
		 * Prints a verbose message to a log file (if Verbose logging is enabled for the given category, 
		 * usually used for detailed logging) 
		 */
		Verbose,

		/** 
		 * Prints a verbose message to a log file (if VeryVerbose logging is enabled, 
		 * usually used for detailed logging that would otherwise spam output) 
		 */
		VeryVerbose,

		// Log masks and special Enum values

		All				= VeryVerbose,
		NumVerbosity,
		VerbosityMask	= 0xf,
		SetColor		= 0x40, // not actually a verbosity, used to set the color of an output device 
		BreakOnLog		= 0x80
	};
}
```


