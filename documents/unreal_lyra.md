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

GCN_Weapon_Pistol_Fire: 射击特效配置，包括开枪音效(BurstSounds)、粒子特效(BurstParticles)，镜头震动(BurstCameraShake)，手柄震动(BurstForceFeedback), 镜头特效(BurstCameraLensEffect)，贴花(BurstDecal)

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

受击动作: GCNL_Character_DamageTaken

### 换弹匣(Reload)

输入配置: InputData_Hero 中添加IA_Weapon_Reload

自动换弹的能力: GA_Weapon_AutoReload

换弹匣动画Montage配置: GA_Weapon_Reload_Rifle, GA_Weapon_Reload_Pistol

动画Montage添加AnimNotify: AN_Reload

弹匣容量、个数配置: ID_Rifle::Fragments. MagazineSize是弹匣容量，MagazineAmmo是第一个弹匣的子弹数量(可以超过弹匣容量), SpareAmmo是剩余子弹总数

玩家初始化后: 总子弹数 == MagazineAmmo + SpareAmmo，可换弹次数 == Floor(SpareAmmo / MagazineSize)

### 持武器动画的同步

持武器动画的位置: B_WeaponInstance_Rifle::EquippedAnimSet::LayerRules -> ABP_RifleAnimLayers -> AO_MM_Rifle_Idle_Hipfire

动画Layer的第三方同步: FLyraEquipmentList::PostReplicatedAdd -> ULyraRangedWeaponInstance::OnEquipped -> ULyraEquipmentInstance::OnEquipped -> B_WeaponInstance_Pistol::Event OnEquipped -> ULyraWeaponInstance::PickBestAnimLayer

动画Layer的第一方逻辑: ULyraQuickBarComponent::EquipItemInSlot -> LyraEquipmentManagerComponent::EquipItem -> ULyraRangedWeaponInstance::OnEquipped

### Q键仍手雷

手雷Ability逻辑: GA_Grenade

手雷Actor: B_Grenade

### 后坐力Recoil

给APawn::AddControllerPitchInput加一个向上的pitch，带动镜头向上走

### 射击的音效

通过gm指令(au.3dVisualize.Enabled = 1)可以观察到音效是: MSS_Weapons_Pistol_Fire

配置: GCN_Weapon_Pistol_Fire::BurstEffects::BurstSounds

步枪rifle的音效: MSS_Weapons_Rifle2_Fire

rifle配置: GCN_Weapon_Rifle_Fire蓝图中: TriggerFIreAudio函数

### CuePath的配置

DefaultGame.ini文件中配置默认的CuePath, 例如[/Script/GameplayAbilities.AbilitySystemGlobals], +GameplayCueNotifyPaths=/Game/GameplayCueNotifies，+GameplayCueNotifyPaths=/Game/GameplayCues

Plugin的GameplayCue的路径配置在: /ShooterCore/ShooterCore::Actions, UGameFeatureAction_AddGameplayCuePath和UGameFeatureAction_AddComponents的配置类似. CuePath包含: /GameplayCues, /Weapons, /Items

除了ShooterCore插件，CuePath还加载了ShooterMaps插件, TopDownArena插件

unreal编辑器启动后，所有的CuePath都汇总到一个全局数组中: UAbilitySystemGlobals::Get().GetGameplayCueNotifyPaths()

插件加载Cue的入口: ULyraGameFeature_AddGameplayCuePaths::OnGameFeatureRegistering

DefaultGame.ini是因为 UAbilitySystemGlobals::GameplayCueNotifyPaths的宏是: UPROPERTY(config)

### Cue的加载，注册

GameplayCue简称GC，所以游戏里Cue基本都是以GC开头。GameplayCueMananger简称GCM

遍历所有CuePath，找到所有的AGameplayCueNotify_Actor、UGameplayCueNotify_Static资源: UGameplayCueManager::InitObjectLibrary -> UObjectLibrary::LoadBlueprintAssetDataFromPaths

加载完成后，所有Cue都保存在: UGameplayCueManager::RuntimeGameplayCueObjectLibrary::CueSet

加入CueDataMap: UGameplayCueManager::InitObjectLibrary -> UGameplayCueSet::AddCues -> BuildAccelerationMap_Internal -> GameplayCueDataMap

所有这些GameplayCue都保存在: GlobalGameplayCueSet(UGameplayCueSet) :: GameplayCueData

最终所有的Cue都会和GameplayCueReferences (类型: GameplayCueRefs)进行关联，估计是为了便于打包或者查找。

Cue的名字保存在: 资源的GameplayCueName属性

log中打印CueDataMap的Gm: GameplayCue.PrintGameplayCueNotifyMap

打印已加载的Cue类: GameplayCue.PrintLoadedGameplayCueNotifyClasses

### 命中的decal贴花

命中角色的decal配置: GCNL_Character_DamageTaken :: BurstEffects :: BurstDecal

FGameplayCueNotify_DecalInfo::SpawnDecal中加断点即可看到调用堆栈

GameplayCue.Character.DamageTaken是GCNL_Character_DamageTaken的位移标识符，外界通过这个找到它, 保存在属性GameplayCueName

GE_Damage_Pistol :: GameplayCues :: GameplayCueTags中配置: GameplayCue.Character.DamageTaken

普通地面的射击decal: B_Weapon -> B_WeaponDecals -> NS_ImpactDecals -> MI_Decal_Concrete 或 MI_Decal_Transparent_Glass

地面decal调用栈: GA_Weapon_Fire_Pistol::Gameplay Cue TagFiring -> GCN_Weapon_Pistol_Fire::OnBurst -> B_Weapon:: Fire Event
