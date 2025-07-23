
## 入门

当你鼠标悬停(Hover)在任意类型资产上，如上图所示，你就可以立即知道此类型的资产有哪些字段是可以搜索的。

比如上图中，就可以搜索到所有帧率不符合规范(30)的动画资产。

下面两张图，是两种常见的其他用法

更多示例见这里：https://dev.epicgames.com/documentation/en-us/unreal-engine/advanced-search-syntax-in-unreal-engine
## 在cpp中定义AssetRegistryTag
第一种方式：Override `GetAssetRegistryTags`后自定义Tag

第二种方式：通过 `AssetRegistrySearchable`宏制定属性为可搜索

## 开发中的用处1：资产批处理工具的基座
AssetRegistryTag最大的好处，就是!!#ff0000 无需Load资产!!，就可以获得资产的一些特殊属性。

因为读取AssetRegistryTag是!!#ff0000 纯内存操作!!，速度极快，非常适合资产的批处理的场景。

以上可以快速读取的属性，本文也称之为**Meta属性**

例如下面的代码就可以快速获取TargetSkeleton的所有动画资产
```cpp

		// Search for all animation assets (adjust classes as needed)
		FARFilter Filter;
		Filter.ClassPaths.Add(UAnimationAsset::StaticClass()->GetClassPathName());
		Filter.bRecursiveClasses = true;
		AssetRegistryModule.Get().GetAssets(Filter, AssetDataList);

		// Check each asset's skeleton
		for (const FAssetData& AssetData : AssetDataList)
		{
			// Get the skeleton reference from the asset's tags
			FString AssetSkeletonName;
			if (AssetData.GetTagValue("Skeleton", AssetSkeletonName))
			{
				if (TargetSkeleton->GetPathName().Equals(AssetSkeletonName))
				{
					OutAnimAssets.Add(AssetData);
				}
			}
		}
```

## 开发中的用处2：SoftPtr资产的Meta属性快速读取
FAssetData::TagsAndValues属性，`GetTagValue`函数都没有被`WITH_EDITORONLY_DATA`宏包住，意味着Runtime理论上也可以用.

很多Asset类的UObject都是用TSoftObjectPtr定义的，TSoftObjectPtr可以很容易转换为FAssetData，从而就可以用`GetTagValue`函数读取这些Tag。

例如：一个属性是TSoftObjectPtr<UAnimMontage>, 使用上述思路，!!#ff0000 无需!!Load(!!#ff0000 加载!!)软引用，就可以获取类似SequenceLength（总时长）属性；

因为SequenceLength是一个`AssetRegistrySearchable`的属性。

