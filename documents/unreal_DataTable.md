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
	
	//负责保存行数据的对象; 也可用宏UPROPERTY(EditAnywhere, meta = (EditInline))
	UPROPERTY(instanced, EditAnywhere)
	TObjectPtr<UObject> ConfigObj;
	
	//监听表的修改操作
	void OnDataTableChanged(const UDataTable* InDataTable, const FName InRowName) override;

};

//如下代码放在cpp文件里

void FYourTableRow::OnDataTableChanged(const UDataTable* InDataTable, const FName InRowName)
{
	
	auto rowData = InDataTable->FindRow<FYourTableRow>(InRowName, TEXT("TryChangeRowConfigType"));
	if (IsValid(rowData->ConfigClass))
	{
		if (!rowData->ConfigObj || !rowData->ConfigObj.GetClass()->IsChildOf(rowData->ConfigClass))
		{
			rowData->ConfigObj = NewObject<UObject>(const_cast<UDataTable*>(InDataTable), rowData->ConfigClass);
		}
	}
	else
	{
		rowData->ConfigObj = nullptr;
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
	
    //负责保存行数据的对象; 也可用宏UPROPERTY(instanced, EditAnywhere, meta = (AllowedClasses = "/Script/YourGame.StateConfig"))
    //注意此处的类型一定要用UObject，不建议用UStateConfig
    UPROPERTY(EditAnywhere, meta = (EditInline, AllowedClasses = "/Script/YourGame.StateConfig"))
    TObjectPtr<UObject> ConfigObj;
	
    //监听表的修改操作
    void OnDataTableChanged(const UDataTable* InDataTable, const FName InRowName) override;

};

//如下代码放在cpp文件里

void FYourTableRow::OnDataTableChanged(const UDataTable* InDataTable, const FName InRowName)
{
	
	auto rowData = InDataTable->FindRow<FYourTableRow>(InRowName, TEXT("TryChangeRowConfigType"));
	if (IsValid(rowData->ConfigClass))
	{
		if (!rowData->ConfigObj || !rowData->ConfigObj.GetClass()->IsChildOf(rowData->ConfigClass))
		{
			rowData->ConfigObj = NewObject<UStateConfig>(const_cast<UDataTable*>(InDataTable), rowData->ConfigClass);
		}
	}
	else
	{
		rowData->ConfigObj = nullptr;
	}
}
```
这样的话，用户就只能选择UStateConfig的子类作为行数据类型了。
