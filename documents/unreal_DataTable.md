# Unreal中的DataTable的Row数据类型的动态化

实现DataTable的每行可以配置不同类型的数据


## 背景

Unreal中的DataTable通常情况下只能定义固定的数据格式，也就是说表内每行可配置的属性个数及类型都是一模一样的。

本文的**创新之处**就是实现了DataTable的每行可以拥有不同的数据结构。


## 总体思路

先加一个TSubclassOf类型的属性A和UObject指针类型的属性B，监听下表格属性修改的操作；当属性A的值发生变化的时候，创建个对应的Object，赋值给属性B。这个属性B就是可以编辑的，且可以保存。

## 任意UObject类型的案例
```cpp
USTRUCT(BlueprintType)
struct FYourTableRow : public FTableRowBase
{
	GENERATED_BODY()

public:
	// 用户可选择的行数据类型
	UPROPERTY(EditAnywhere)
	TSubclassOf<UObject> ConfigClass;
	
	//负责保存行数据的对象; 
	UPROPERTY(EditAnywhere, meta = (EditInline))
	TObjectPtr<UObject> ConfigObj;
	
	//监听表的修改操作
	void OnDataTableChanged(const UDataTable* InDataTable, const FName InRowName) override;

};

//如下代码放在cpp文件里

void FYourTableRow::OnDataTableChanged(const UDataTable* InDataTable, const FName InRowName)
{
	
	if (IsValid(ConfigClass))
	{
		if (!ConfigObj || ConfigObj.GetClass() != ConfigClass.Get())
		{
			ConfigObj = NewObject<UObject>(const_cast<UDataTable*>(InDataTable), ConfigClass);
		}
	}
	else
	{
		ConfigObj = nullptr;
	}
}
```
以上案例实现了表内的行可以配置任意类型的UObject。

但是，实际需求中，通常不需要如此灵活的配置，要限定所有Row的类型的父类为特定的class。

## 限定Row类型的父类为特定Class

本文假设这个特定Class为: UStateConfig
```cpp
// 假设如下代码所在的module名为YourGame，module具体名称可以查看最近的Build.cs文件
// 所以，UStateConfig类型的路径就是: /Script/YourGame.StateConfig
// 也可以用UCLASS(Blueprintable)
UCLASS(BlueprintType)
class UStateConfig: public UObject
{
	GENERATED_BODY()
};
```

那么，表的定义改为如下格式即可
```cpp
USTRUCT(BlueprintType)
struct FYourTableRow : public FTableRowBase
{
	GENERATED_BODY()

public:
    // 用户可选择的数据类型, 限定为UStateConfig的子类
    UPROPERTY(EditAnywhere)
    TSubclassOf<UStateConfig> ConfigClass;
	
    //负责保存行数据的对象; 注意千万不要用instanced替代EditInline, 因为instanced Implies EditInline and Export. Export会导致此属性复制粘贴过程Crash
    //注意此处的类型一定要用UObject，不建议用UStateConfig
    UPROPERTY(EditAnywhere, meta = (EditInline, AllowedClasses = "/Script/YourGame.StateConfig"))
    TObjectPtr<UObject> ConfigObj;
	
    //监听表的修改操作
    void OnDataTableChanged(const UDataTable* InDataTable, const FName InRowName) override;

};

//如下代码放在cpp文件里

void FYourTableRow::OnDataTableChanged(const UDataTable* InDataTable, const FName InRowName)
{
    // 内容和上文函数相同即可
}
```
这样的话，用户就只能选择UStateConfig的子类作为行数据类型了。

## 如何查看DataTable中ConfigObj属性(UObject 类型)的Diff

如何看DataTable的Diff呢: DataTable右键菜单 -> Source Control -> History, 会弹出File History窗口; 在File History窗口: 选中你感兴趣的一行Revision, 右键菜单 -> Diff Against Previous Revision

虽然ConfigObj中存储的数据实现了类型的动态化，但是，在实际使用中，我们经常需要查看别人改了ConfigObj的哪个字段.

可是对于Object类型的属性，DataTable的默认行为，只会导出Object的Path，不会导出Object内部的任何字段；如此，ConfigObj的Diff就无法看到改了什么字段


### 先确保DataTable导出为Json格式的时候，包含ConfigObj的字段

找到Engine中的DataTableJSON.cpp文件，修改函数TDataTableExporterJSON<CharType>::WriteStruct
```cpp
// bool TDataTableExporterJSON<CharType>::WriteStruct(const UScriptStruct* InStruct, const void* InStructData, const FString* FieldToSkip)
bool TDataTableExporterJSON<CharType>::WriteStruct(const UStruct* InStruct, const void* InStructData, const FString* FieldToSkip)
```
然后，在WriteStructEntry函数中添加如下代码:
```cpp
bool TDataTableExporterJSON<CharType>::WriteStructEntry(const void* InRowData, const FProperty* InProperty, const void* InPropertyData)
{
    ......
	else if (const FObjectPropertyBase* ObjectProp = CastField<const FObjectPropertyBase>(InProperty))
	{
		UObject* Object = ObjectProp->GetObjectPropertyValue(InPropertyData);
		if (IsValid(Object) && Object->GetOutermostObject() && Object->GetOutermostObject()->IsA<UDataTable>() && !!(DTExportFlags & EDataTableExportFlags::UseJsonObjectsForStructs))
		{
			JsonWriter->WriteObjectStart(Identifier);
			WriteStruct(Object->GetClass(), Object);
			JsonWriter->WriteObjectEnd();
		}
		else
		{
			const FString PropertyValue = DataTableUtils::GetPropertyValueAsString(InProperty, (uint8*)InRowData, DTExportFlags);
			JsonWriter->WriteValue(Identifier, PropertyValue);
		}
	}
    ......
}
```

验证: DataTable右键菜单 -> Export As JSON

### 将CSV格式的导出逻辑也改为包含ConfigObj字段

你加Breakpoint观察可以发现，unreal看diff的时候，默认用的就是CSV格式; 也就是CSV的导出结果是正确的话，diff自然也就好了

找到Engine的DataTableUtils.cpp文件，修改函数GetPropertyValueAsStringDirect如下
```cpp
void GetPropertyValueAsStringDirect(const FProperty* InProp, const uint8* InData, const int32 InPortFlags, const EDataTableExportFlags InDTExportFlags, FString& OutString)
{
#if WITH_EDITOR
    //将ExportStructAsJson的定义挪到最前方
    auto ExportStructAsJson = .....
    ......
    if (const FObjectPropertyBase* ObjectProp = CastField<const FObjectPropertyBase>(InProp))
	{
		const UObject* Object = ObjectProp->GetObjectPropertyValue(InData);
		if (IsValid(Object) && Object->GetOutermostObject() && Object->GetOutermostObject()->IsA<UDataTable>())
		{
			OutString.Append(ExportStructAsJson(Object->GetClass(), Object));
			return;
		}
	}
#endif // WITH_EDITOR
    ......
}
```

至此，我们就解决了无法看object的Diff的烦恼。

验证: DataTable右键菜单 -> Export As CSV

## 一些注意事项

### OnDataTableChanged函数加载时机过早的问题

实测中发现，在UnrealEditor启动过程中，也会触发OnDataTableChanged函数。

如果你的实际需求和我们类似：希望只在编辑DataTable的时候触发，不希望加载DataTable的时候触发OnDataTableChanged，那么可以用如下代码过滤

```cpp
#if !PLATFORM_MAC
    // 判断编辑器是否加载完成
	if(! FGlobalTabmanager::Get()->GetRootWindow().IsValid())
	{
		return;
	}
#endif
```

### UStateConfig属性显示不出来的问题

```cpp
// 正确的属性定义
UPROPERTY(EditAnywhere, Category = "Animation")

// 正确的属性定义
UPROPERTY(EditDefaultsOnly)

// 错误的定义: 由于不可编辑，所以表格中不会显示此属性
UPROPERTY()

// 错误的定义: Category字段不允许包含'|'，否则也会不显示
UPROPERTY(EditAnywhere, Category = "Gameplay|Animation")
```


一个检查属性问题的代码

```cpp
auto ConfigProp = ConfigClass->PropertyLink;
while (ConfigProp)
{
    if (const auto CategoryString = ConfigProp->FindMetaData(TEXT("Category")))
    {
        if (CategoryString->Contains(TEXT("|")))
        {
            // report error
        }

    }
    if((ConfigProp->PropertyFlags & CPF_Edit) != CPF_Edit)
    {
        // report error
    }

    ConfigProp = ConfigProp->PropertyLinkNext;
}
```
