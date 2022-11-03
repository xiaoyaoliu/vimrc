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

WID_Pistol: 挂点配置

GA_Weapon_Reload_Pistol: 换弹夹的逻辑和配置

ID_Pistol: 弹匣容量，弹匣个数。UI图标配置

### ULyraQuickBarComponent

创建: UGameFeatureAction_AddComponents::AddToWorld -> UGameFrameworkComponentManager::AddComponentRequest -> UGameFrameworkComponentManager::CreateComponentOnInstance

UGameFeatureAction_AddComponents的激活: ULyraExperienceManagerComponent::OnExperienceLoadComplete -> UGameFeaturesSubsystem::Get().LoadAndActivateGameFeaturePlugin

UGameFeatureAction_AddComponents的配置: B_ShooterGame_Elimination::GameFeaturesToEnable(插件名，例如: ShooterCore) -> /ShooterCore/ShooterCore::Actions

ShooterCore的UGameFeatureAction_AddComponents::ComponentList中包含: B_EliminationFeedReplay，LyraEquipmentManagerComponent，LyraIndicatorManagerComponent，LyraInventoryManagerComponent, LyraWeaponStateComponent, B_AimAssistTargetManager

ULyraQuickBarComponent的配置:  B_ShooterGame_Elimination::ActionSets -> LAS_ShooterGame_StandardComponents::ComponentList

### 射击过程

输入配置: InputData_Hero, IMC_Default_KBM

键盘输入: LyraHeroComponent::OnInputConfigActivated -> ULyraGameplayAbility_RangedWeapon::StartRangedWeaponTargeting

射击伤害: OnRangedWeaponTargetDataReady -> BP_ApplyGameplayEffectToTarget -> ULyraDamageExecution::Execute_Implementation -> GE_Damage_RifleAuto

射击伤害蓝图: GA_Weapon_Fire::EventOnRangedWeaponTargetDataReady

lyra伤害的父类: GameplayEffectParent_Damage_Basic

射击同步:  [client] OnRangedWeaponTargetDataReady -> UAbilitySystemComponent::CallServerSetReplicatedTargetData -> 【server】ServerSetReplicatedTargetData_Implementation (AbilitySystemComponent_Abilities.cpp) -> [server]OnRangedWeaponTargetDataReady

### 换弹匣(Reload)

输入配置: InputData_Hero 中添加IA_Weapon_Reload

自动换弹的能力: GA_Weapon_AutoReload

换弹匣动画Montage配置: GA_Weapon_Reload_Rifle, GA_Weapon_Reload_Pistol

动画Montage添加AnimNotify: AN_Notify

弹匣容量、个数配置: ID_Rifle::Fragments. MagazineSize是弹匣容量，MagazineAmmo是第一个弹匣的子弹数量(可以超过弹匣容量), SpareAmmo是剩余子弹总数

玩家初始化后: 总子弹数 == MagazineAmmo + SpareAmmo，可换弹次数 == Floor(SpareAmmo / MagazineSize)
