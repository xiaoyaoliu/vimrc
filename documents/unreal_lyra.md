## weapon

### configs

配置文件: /ShooterCore/Game/Respawn/DT_RespawnInitItems 在UFeRespawnInitItemsConfig::LoadConfig

当能力UFeRespawnInitItemsAbility激活的时候，会读取配置DT_RespawnInitItems。 

HeroData_ShooterGame中的AbilitySets属性为: AbilitySet_ShooterHero

AbilitySet_ShooterHero中会引用: UFeRespawnInitItemsAbility

在ALyraPlayerState::SetPawnData函数中，AbilitySets中的各种能力都会GiveTo玩家

### 手枪pistol能力的初始化

首先将DT_RespawnInitItems中的Equip都添加到ULyraInventoryManagerComponent::InventoryList

然后将武器槽的active索引设置为0，0是手枪(ID_Pistol)，1是步枪: ULyraQuickBarComponent::SetActiveSlotIndex

创建手枪Instance (B_WeaponInstance_Pistol): ULyraQuickBarComponent::EquipItemInSlot -> ULyraEquipmentManagerComponent::EquipItem -> FLyraEquipmentList::AddEntry

手枪Instance: 配置在WID_Pistol::InstanceType，保存在FLyraAppliedEquipmentEntry::Entries

手枪Ability: 配置在WID_Pistol::AbilitySetsToGrant, 在AddEntry函数中初始化

手枪模型的挂接: 配置在WID_Pistol::ActorsToSpawn，ULyraEquipmentInstance::SpawnEquipmentActors中挂接手枪

WID_Pistol配置在: ID_Pistol::Fragments -> UInventoryFragment_EquippableItem::EquipmentDefinition

### /ShooterCore/Weapons/Pistol文件夹中各个文件的作用

AbilitySet_ShooterPistol: 手枪的能力集合，包括换弹、自动换弹、射击

B_Pistol: 手枪的actor，模型

B_WeaponInstance_Pistol: 手枪的Equip Instance. 手枪射击的主要参数都在这里: 射程、伤害、Falloff、射击动画、debug参数、角色移速

GA_Weapon_Fire_Pistol: 手枪的射击能力，主管射击逻辑
