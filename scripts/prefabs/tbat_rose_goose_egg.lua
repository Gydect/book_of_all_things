local assets =
{
    Asset("ANIM", "anim/tbat_rose_goose_egg.zip"),
}

local prefabs_portable =
{
    "tbat_rose_goose_egg",
}

local prefabs_item =
{
    "tbat_rose_goose_egg_portable",
}

local function GetDefaultMaster()
    return TheWorld ~= nil and TheWorld:GetPocketDimensionContainer("tbat_rose_twin_goose") or nil
end

local function GetContainerMaster(inst)
    return inst.components.container_proxy ~= nil and inst.components.container_proxy:GetMaster() or nil
end

local function SetContainerMaster(inst, master)
    if inst.components.container_proxy ~= nil then
        inst.components.container_proxy:SetMaster(master or GetDefaultMaster())
    end
end

local function RefreshTwinGooseState(inst)
    local world = TheWorld
    if world == nil or not world:IsValid() then
        return
    end

    local container_proxy = inst.components.container_proxy
    if container_proxy == nil then
        return
    end

    local level = world.GetTBATTwinGooseLevel ~= nil and world:GetTBATTwinGooseLevel() or 0
    container_proxy:SetCanBeOpened(level >= 2)
end

local function AttachContainer(inst)
    SetContainerMaster(inst, GetDefaultMaster())
end

local function WatchTwinGooseState(inst)
    inst:ListenForEvent("tbat_refresh_twin_goose_state",
        function()
            RefreshTwinGooseState(inst)
        end, TheWorld)
    RefreshTwinGooseState(inst)
end

local function ChangeToItem(inst)
    local master = GetContainerMaster(inst)
    if inst.components.container_proxy ~= nil then
        inst.components.container_proxy:Close()
    end

    local item = SpawnPrefab("tbat_rose_goose_egg")
    if item ~= nil then
        item.Transform:SetPosition(inst.Transform:GetWorldPosition())
        SetContainerMaster(item, master)
        RefreshTwinGooseState(item)
    end

    inst:Remove()
end

local function onhammered(inst, worker)
    ChangeToItem(inst)
end

local function ondeploy(inst, pt, deployer)
    local master = GetContainerMaster(inst)
    if inst.components.container_proxy ~= nil then
        inst.components.container_proxy:Close()
    end
    local portable = SpawnPrefab("tbat_rose_goose_egg_portable")
    if portable ~= nil then
        portable.Physics:SetCollides(false)
        portable.Physics:Teleport(pt.x, 0, pt.z)
        portable.Physics:SetCollides(true)

        portable.AnimState:PlayAnimation("idle")
        SetContainerMaster(portable, master)
        RefreshTwinGooseState(portable)

        inst:Remove()
        PreventCharacterCollisionsWithPlacedObjects(portable)
    end
end

local function portablefn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    inst:SetDeploySmartRadius(0)
    inst:SetPhysicsRadiusOverride(0)
    MakeObstaclePhysics(inst, 0, 0)

    inst.AnimState:SetBank("tbat_rose_goose_egg")
    inst.AnimState:SetBuild("tbat_rose_goose_egg")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("container_proxy")

    inst:AddTag("structure")
    -- inst:AddTag("tbat_rose_goose_egg")

    inst:SetPrefabNameOverride("tbat_rose_goose_egg")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("portablestructure")
    inst.components.portablestructure:SetOnDismantleFn(ChangeToItem)

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(9)
    inst.components.workable:SetOnFinishCallback(onhammered)

    inst:AddComponent("hauntable")
    inst.components.hauntable:SetHauntValue(TUNING.HAUNT_TINY)

    inst.OnLoadPostPass = AttachContainer

    if not POPULATING then
        AttachContainer(inst)
    end

    WatchTwinGooseState(inst)

    return inst
end

local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tbat_rose_goose_egg")
    inst.AnimState:SetBuild("tbat_rose_goose_egg")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("container_proxy")

    inst:AddTag("tbat_rose_goose_egg")
    inst:AddTag("portableitem")

    MakeInventoryFloatable(inst, "small", 0.15)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    -- inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.DEFAULT)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)

    MakeHauntablePerish(inst)

    inst.OnLoadPostPass = AttachContainer

    if not POPULATING then
        AttachContainer(inst)
    end

    WatchTwinGooseState(inst)

    return inst
end

return
    Prefab("tbat_rose_goose_egg_portable", portablefn, assets, prefabs_portable),
    Prefab("tbat_rose_goose_egg", itemfn, assets, prefabs_item),
    MakePlacer("tbat_rose_goose_egg_placer", "tbat_rose_goose_egg", "tbat_rose_goose_egg", "idle")
