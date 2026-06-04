# Unreal SkeletalMesh编辑器的一些注意事项

## SkeletalMesh资产: 自带删除Bone的功能有bug

有需求要在UnrealEditor里删除某些Bone, Unreal恰好自带删除Lod骨骼的功能, 我们就直接用了。

当我们用Unreal自带的功能给Asset A删除骨骼后，编辑器里看起来骨骼确实被删除了。

但是Reload Asset A (或 重启Editor)后, Asset A被删的Bone又回来了, 等于什么也没做。

就是个非常神奇的bug: 你明明已经删掉骨骼上传了，其他同事却怀疑你漏提交了吧？你自查提交了呀, 结果手动Reload资产后发现自己确实啥都没改成。

删除骨骼的Editor入口: 打开一个SkeletalMesh资产 -> 选中Skeleton Tree窗口 -> 待删骨骼的右键菜单 -> Remove Selected.../Children... -> From LOD 0 and below

删除骨骼的Code入口:  SSkeletonTree::RemoveFromLOD

定位大概过程: 
1. RemoveFromLOD函数写的看起来天衣无缝，推测问题应该是出在Load资产的过程中
2. USkeletalMesh::ExecuteBuildInternal-> FSkeletalMeshRenderData::Cache, 看到DDC，怀疑是读了缓存所致: https://dev.epicgames.com/documentation/en-us/unreal-engine/using-derived-data-cache-in-unreal-engine
3. 在RemoveFromLOD函数里调用`USkeletalMesh::InvalidateDeriveDataCacheGUID`：让SkeletalMesh对应的DDC缓存失效, 结果bug依旧在
4. 不读DDC缓存了，但是会触发SkeletalMesh的Build: `USkeletalMesh::BuildLODModel`
5. Build过程貌似会从ImportedModel里读取骨骼数据，覆盖掉你删骨骼的修改.

最终解决关键Code如下
```cpp
void SSkeletonTree::RemoveFromLOD(int32 LODIndex, bool bIncludeSelected, bool bIncludeBelowLODs)
{
    ......
	    //Scoped post edit change
		{
			FScopedSkeletalMeshPostEditChange ScopedPostEditChange(PreviewMeshComponent->GetSkeletalMeshAsset());
			if (IsInGameThread())
			{
				// very important: Rebuild DDC Cache
				PreviewMeshComponent->GetSkeletalMeshAsset()->InvalidateDeriveDataCacheGUID();
				// very important: avoid to BuildSkeletalMesh(USkeletalMesh::BuildLODModel) use Imported Data.
				PreviewMeshComponent->GetSkeletalMeshAsset()->EmptyAllImportData();
			}
            ......
        }
    ......
}
```
ImportedData应该是美术导入的原始数据，这个数据美术仓库里的fbx文件里也有对应的信息，SkeletalMesh资产本身也不依赖ImportedData, 所以清空ImportedData不会有什么副作用。
