## Unreal Command

unreal的Gm指令输入方式: 在编辑器下方状态栏有输入框(Enter Console Command)

command大多定义在: BaseInput.ini

### Animation

需要先启动游戏

打开动画Debug信息的GM: ShowDebug ANIMATION

由于动画树通常很大，占用过多屏幕空间，经常需要隐藏动画树: ShowDebugToggleSubCategory GRAPH

相关代码: AHUD::ShowDebug -> ACharacter::DisplayDebug -> UAnimInstance::DisplayDebug

TODO: 如何查看第三方动画的Debug Info ?

### Audio Sound

官方文档: https://docs.unrealengine.com/5.0/en-US/audio-console-commands-in-unreal-engine/

运行时音效可视化gm: au.3dVisualize.Enabled = 1
