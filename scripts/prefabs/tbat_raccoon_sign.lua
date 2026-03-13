require "prefabutil"

local assets =
{
    Asset("ANIM", "anim/tbat_raccoon_sign.zip"),
}

local prefabs =
{
    "collapse_small",
}

local function onhammered(inst, worker)
    inst.components.lootdropper:DropLoot()
    local fx = SpawnPrefab("collapse_small")
    fx.Transform:SetPosition(inst.Transform:GetWorldPosition())
    fx:SetMaterial("wood")
    inst:Remove()
end

local function onbuilt(inst)
    inst.SoundEmitter:PlaySound("dontstarve/common/sign_craft")
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    -- inst:SetDeploySmartRadius(0.75)
    -- MakeObstaclePhysics(inst, .2)

    inst.AnimState:SetBank("tbat_raccoon_sign")
    inst.AnimState:SetBuild("tbat_raccoon_sign")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:OverrideSymbol("content", "tbat_raccoon_sign_content", "default")

    inst:AddTag("structure")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")
    inst:AddComponent("lootdropper")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(9)
    inst.components.workable:SetOnFinishCallback(onhammered)

    MakeHauntableWork(inst)
    inst:ListenForEvent("onbuilt", onbuilt)

    return inst
end

return Prefab("tbat_raccoon_sign", fn, assets, prefabs),
    MakePlacer("tbat_raccoon_sign_placer", "tbat_raccoon_sign", "tbat_raccoon_sign", "idle")
