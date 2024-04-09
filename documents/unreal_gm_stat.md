
## state llmfull: 分析Unreal内存

启动Editor添加 -llm参数

启动Game后，输入Gm: stat llmfull

### 源码分析

Stats\StatsCommand.cpp 中的NewFrame函数会收集内存信息: 使用StatsData.cpp中 FStatsThreadState::GetRawStackStats函数从Frame.Packets中收集内存

Frame.Packets的写入: Stat2.h中的AddStatMessage

渲染分析结果： StatsRender2.cpp中RenderGroupedWithHierarchy函数 -> RenderMemoryCounter函数

### 经典案例

有次发现启动游戏后，Physics占用了20G的内存

后来DefaultShapeComplexity设置为CTF_UseSimpleAsComplex(关闭Complex碰撞), Physics占用内存下降到了3G左右
