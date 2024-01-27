## Low Poly Shooter Pack

https://www.unrealengine.com/marketplace/en-US/product/low-poly-fps-pack

## 相机Update
BP_LPSP_PCH蓝图 Update Field Of View

相机会读取动画蓝图ABP_LPSP_FP_PCH的Field of View的动画曲线: CGraph Field Of View -> LPSP - Get Field Of View -> Field Of View Standing

FOV最终读取的是: BP_LPSP_PCH蓝图的LPSP - Get Field Of View

## First Person视角

BP_LPSP_PCH蓝图

Possessed -> Cached: Is AI -> Event Destroy First-Person Components

## 武器Weapon

Spawn: BPSC_LPSP_Inventory蓝图 Spawn Initial Items函数，AttachActorTo Component(BPSC_LPSP_Inventory)

挂接Attach: BPSC_LPSP_CH_Viewmode_Handler蓝图中的Event Update Viewmode Setup

武器的配置： 都在BPSC_LPSP_Inventory::Starting Items变量中 

武器的配置表: DT_LPAMG_Inventory DT_LPSP_Inventory

每个角色蓝图中，找到对应的Inventory Component，修改Starting Items属性即可

## FPP TPP切换

BP_LPSP_PCH蓝图 On Update Viewmode -> UPrimitiveComponent::SetOwnerNoSee

viewmode的切换在: BPSC_LPSP_CH_Viewmode_Handler蓝图Event Update Viewmode

## 造成手臂不显示的原因

蓝图BP_LPSP_PCH 函数Try Set Field Of View Alpha

Set Scalar Parameter Value on Materials(Skeletal Mesh Arms)

parameter name: Field Of View Alpha

不设置这个material参数，手臂就显示出来了

## 造成武器不显示的原因


蓝图BP_LPSP_PCH 函数Update Current Weapon -> Update Equipped Item Viewmodel

蓝图BP_LPSP_WEP 函数 EventLPSP - Update Viewmodel -> Event Set Viewmodel

蓝图BPAC_IG_Viewmodel_Helper函数 Update Meshes -> Set Scalar Parameter Value on Materials(Parameter name: Field Of View Alpha)

## Reload换弹匣

logic入口: BP_LPSP_PCH蓝图的 CGraph Reload函数

播放角色Montage的地方: BP_LPSP_PCH蓝图 Event On Reload -> Try Play Montage By Name

配置角色Montage的地方： DT_LPAMG_WEP_Information表

角色montage资源示例: AM_LPSP_FP_PCH_AG14W_Reload_Empty AM_LPSP_FP_PCH_AG14W_Reload

换弹逻辑整体都是由角色Montage中各种AnimNotify驱动的

弹匣的两个挂接点： SOCKET_Magazine_Reserve SOCKET_Magazine

弹匣的配置：DT_LPAMG_WEP_AG14W_Settings_Magazines

弹匣掉落： BP_ALPW_AN_Magazine_Drop -> BP_LPSP_WEP蓝图的Spawn Drop Magazine函数

换弹匣的动画本质上是一个武器动画，新的弹匣挂接在Reserve Magazine上，老的弹匣挂接在Magazine下面

AG14W武器动画的配置在: DT_LPAMG_WEP_Information -> DT_LPAMG_WEP_AG14W_Montages

武器动画的Play: BP_LPSP_WEP蓝图的Event LPSP - Montage Play

## Abilities

配置在:  DT_LPAMG_WEP_Information表 -> DT_LPAMG_CH_Abilities表

表的获取: BP_LPSP_WEP蓝图的CGraph Cache Character Abilities中设置了Player Character Abilities变量， BP_LPSP_PCH接口通过Update Current Weapon函数LPSP - Get Character Abilities接口设置到Abilities变量中

## 消音器

典型的消音器: BP_LPSP_WEP_Silencer_03

挂消音器的枪: BP_LPSP_WEP_AR_01

配表: DT_LPSP_Actors_Muzzles

挂消音器到枪上的蓝图位置: BP_LPSP_WEP的CGraph Swap Muzzle
