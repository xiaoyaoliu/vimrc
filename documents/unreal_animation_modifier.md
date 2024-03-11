## Unreal的AnimationModifier

UAnimationModifier是官方提供的批量修改AnimSequence的方法

以一个需求为例：

1. 项目中通常有一个参与蒙皮的FootL骨骼，还有一个挂在Root骨骼下不参与蒙皮的IkFootL骨骼
1. 通常对于一个AnimSequence骨骼，FootL骨骼应该和IkFootL骨骼，在角色空间上完全对齐
1. 但是实际上美术输出的AnimSequence资产里，这两个骨骼不一定是对齐的，那么如何修复呢？


UCopyBonesModifier就是UAnimationModifier的一个子类，可以将一个Bone的数据Copy给另外一个Bone

本文的案例，就是用UCopyBonesModifier, 将FootL骨骼的数据Copy给IkFootL骨骼，从而解决这个问题

## 使用AnimationModifier

1. 在内容浏览器(Content Browser)里选中有问题的AnimSequence, 鼠标右键点一下
1. 选择Animation Modifier(s) -> Add Modifier, 弹出一个新的对话框
1. 对话框左上角下拉框选择CopyBonesModifier, 在中间选中你新加的CopyBonesModifier，下方会显示一些Settings的属性
1. 在Settings区域，找到BonePairs，+号添加一个Pair, Source Bone填FootL, Target Bone填IkFootL
1. Bone Pose Space保持默认的World，最后点下Apply按钮，就修改成功啦

注意：修改成功后的AnimSeuqnce文件，打开后AssetUserData属性里会多出一个UAnimationModifiersAssetUserData

## 批量使用AnimationModifier

1. 在Content Browser里使用Filters: 选择Animation -> Animation Sequence来过滤资产。

1. 在Content Browser里按住shift或者Ctrl来批量选择Animation资产

1. 鼠标右键，然后和上一节方法相同


## 一些个人感悟

以后开发一些修改AnimationSequence的工具，尽量用AnimationModifier来做，而不是传统的使用UAnimMetaData

有时间再研究下Unreal自带的其他类型的AnimationModifier
