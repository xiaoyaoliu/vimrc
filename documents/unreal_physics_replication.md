## Unreal5.3 物理同步(Physics Replication)的一些问题

物理同步相关文章：https://zhuanlan.zhihu.com/p/341447703

Unreal5.3 开启物理同步的方法，DefaultEngine.ini中设置`bEnablePhysicsReplication=true`即可

```ini
[/Script/Engine.PhysicsSettings]
PhysicsPrediction=(bEnablePhysicsPrediction=True,bEnablePhysicsResimulation=False,ResimulationErrorThreshold=10.000000,MaxSupportedLatencyPrediction=1000.000000)
```

## 基本背景

Unreal的默认模式是服务端做物理Simulate，然后由Server来同步其物理状态给所有客户端。

服务器Replicated物理状态, 重点关注如下两个函数：
1.  FPhysScene_Chaos::PopulateReplicationCache 缓存物理状态
2. AActor::GatherCurrentMovement 读取缓存，设置ReplicatedMovement

客户端接收到ReplicatedMovement后，设置物理状态, 重点关注如下两个函数：
1. AWeaponThrowActor::OnRep_ReplicatedMovement 总入口，一步一步跟进去看看即可， 最后到FPhysicsReplication::SetReplicatedTarget
1. FPhysicsReplicationAsync::OnPreSimulate_Internal 物理线程同步入口，所有的同步模式都会走ApplyTargetStatesAsync


Default模式：截至到5.3，会走DefaultReplication_DEPRECATED(), 并不会走DefaultReplication()
PredictiveInterpolation模式：会走PredictiveInterpolation()
Resimulation模式：会走ResimulationReplication()


## 第一方做物理Simulate，Server做转发和校验，第三方做物理同步

我们有需求是第一方做物理Simulate，Server关闭物理Simulate，Server只做转发和校验。

但是实际测试效果并不好，第三方同步的效果落地后有很大的跳变。

经过排查，发现问题出在PredictiveInterpolation()函数, 以下是我摘取的一段Unreal的代码：
```cpp
bool FPhysicsReplicationAsync::PredictiveInterpolation(Chaos::FPBDRigidParticleHandle* Handle, FReplicatedPhysicsTargetAsync& Target, const float DeltaSeconds)
{
	FRigidBodyState CurrentState;
	CurrentState.Position = Handle->X();
	CurrentState.Quaternion = Handle->R();
	CurrentState.LinVel = Handle->V();
    CurrentState.AngVel = Handle->W();
    const bool bHardSnap = Target.AccumulatedErrorSeconds > ErrorAccumulationSeconds || CharacterMovementCVars::bPredictiveInterpolationAlwaysHardSnap;
    if (bHardSnap)
	{
		// Too much error so just snap state here and be done with it
		Target.AccumulatedErrorSeconds = 0.0f;
		Handle->SetX(Target.PrevPosTarget);
		Handle->SetP(Target.PrevPosTarget);
		Handle->SetR(Target.PrevRotTarget);
		Handle->SetQ(Target.PrevRotTarget);
		Handle->SetV(Target.TargetState.LinVel);
		Handle->SetW(Target.TargetState.AngVel);
	}else
    { 
        float CurAngVelSize;
		FVector CurAngVelAxis;
		CurrentState.AngVel.FVector::ToDirectionAndLength(CurAngVelAxis, CurAngVelSize);
		CurAngVelSize = FMath::DegreesToRadians(CurAngVelSize);
		const FQuat CurRotExtrapDelta = FQuat(CurAngVelAxis, CurAngVelSize * DeltaSeconds);
    }
}
```

大家觉得上述代码有什么问题吗？？？

问题1： Handle->W()是底层物理引擎的角速度，单位是弧度Radians，但是CurAngVelSize = FMath::DegreesToRadians(CurAngVelSize);将其看作了Degree，单位对不上;

问题2：观察PhysicsReplication.cpp的上下文，发现其大部分代码的AngVel属性的单位都是Degree（例如FPhysicsReplicationAsync::DefaultReplication函数)而SetW的单位是Radians，这又是一个单位不一致的问题。

问题3：bPredictiveInterpolationAlwaysHardSnap的默认值是True，意味着这个函数并没有做任何的Interpolation, 和其名字的含义不符合。

正是因为问题2，导致第三方把角度当弧度处理，导致了角速度极大，从而第三方的物理同步后，物体碰到地面可能会飞起来，造成效果很差

## 修复方案

总体思路：将代码中所有的AngVel属性的单位都改为Degrees, SetW的参数都改为Radians
```cpp

// PhysicsReplication.cpp中所有的AngVel属性的赋值都改为如下形式
CurrentState.AngVel = FMath::RadiansToDegrees(Handle->W());

Handle->SetW(FMath::DegreesToRadians(Target.TargetState.AngVel));
```

然后还要修改PhysScene_Chaos.cpp, PrimitiveComponentPhysics.cpp, 保证服务器上的AngVel单位是Degree
```cpp
// PhysScene_Chaos.cpp
void FPhysScene_Chaos::PopulateReplicationCache(const int32 PhysicsStep)
{
    
    // ReplicationState.AngVel = Handle->W();
	ReplicationState.AngVel = FMath::RadiansToDegrees(Handle->W());
}

bool UPrimitiveComponent::GetRigidBodyState(FRigidBodyState& OutState, FName BoneName)
{
    // OutState.AngVel = Interface->GetW(PhysicsObject);
    OutState.AngVel = FMath::RadiansToDegrees(Interface->GetW(PhysicsObject));
}
```

AngVel统一为Degree的好处有：
1. 比统一为Radians的改动幅度要小
2. 加BreakPoint调试的时候，Degree的可读性更强

最后，要把CharacterMovementCVars::bPredictiveInterpolationAlwaysHardSnap设置为False，这样才能做到Interpolation
