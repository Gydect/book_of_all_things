local assets =
{
    Asset("ANIM", "anim/tbat_pathway_slab.zip"),
    Asset("ANIM", "anim/tbat_pathway_slab_skin1.zip"),
    Asset("ANIM", "anim/tbat_pathway_slab_skin2.zip"),
    Asset("ANIM", "anim/tbat_pathway_slab_skin3.zip"),
}

local prefabs =
{
    "tbat_pathway_slab_item",
}

local prefabs_item =
{
    "tbat_pathway_slab",
}

local function ChangeToItem(inst)
    local item = SpawnPrefab("tbat_pathway_slab_item")
    item.Transform:SetPosition(inst.Transform:GetWorldPosition())
    inst:Remove()
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    -- inst.Transform:SetEightFaced()

    inst.AnimState:SetBank("tbat_pathway_slab")
    inst.AnimState:SetBuild("tbat_pathway_slab")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst:AddTag("structure")
    inst:AddTag("rotatableobject")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    inst:AddComponent("inspectable")

    inst:AddComponent("workable")
    inst.components.workable:SetWorkAction(ACTIONS.HAMMER)
    inst.components.workable:SetWorkLeft(9)
    inst.components.workable:SetOnFinishCallback(ChangeToItem)

    inst:AddComponent("savedrotation")
    inst.components.savedrotation.dodelayedpostpassapply = true

    return inst
end

--------------------------------------------------------------------------

local function ondeploy(inst, pt, deployer, rot)
    local slab = nil
    local num = inst._placer:value()
    if num == 0 then
        slab = SpawnPrefab("tbat_pathway_slab")
    else
        slab = SpawnPrefab("tbat_pathway_slab", "tbat_pathway_slab_skin" .. num, 0)
    end
    if slab then
        slab.Transform:SetPosition(pt.x, 0, pt.z)
        slab.Transform:SetRotation(rot)
        inst:Remove()
    end
end

-- local FLOATABLE_SCALE = { 1.3, 0.9, 1.3 }

local function set_placer(inst)
    local num = inst._placer:value()
    if num == 0 then
        inst.overridedeployplacername = "tbat_pathway_slab_item_placer"
    else
        inst.overridedeployplacername = "tbat_pathway_slab_item_skin" .. num .. "_placer"
    end
end

local function itemfn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    -- inst.Transform:SetEightFaced()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tbat_pathway_slab")
    inst.AnimState:SetBuild("tbat_pathway_slab")
    inst.AnimState:PlayAnimation("idle")
    inst.AnimState:SetOrientation(ANIM_ORIENTATION.OnGround)
    inst.AnimState:SetLayer(LAYER_BACKGROUND)
    inst.AnimState:SetSortOrder(3)

    inst.Transform:SetScale(0.8, 0.8, 0.8)

    inst.overridedeployplacername = "tbat_pathway_slab_item_placer"

    inst._placer = net_smallbyte(inst.GUID, "tbat_pathway_slab_item._placer", "tbat_placer_change")

    -- inst:AddTag()

    MakeInventoryFloatable(inst, "small", nil, 0)

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        inst:ListenForEvent("tbat_placer_change", set_placer)
        return inst
    end

    inst._placer:set(0)

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("stackable")
    inst.components.stackable.maxsize = TUNING.STACK_SIZE_SMALLITEM

    inst:AddComponent("deployable")
    inst.components.deployable.ondeploy = ondeploy
    -- inst.components.deployable:SetDeployMode(DEPLOYMODE.ANYWHERE)
    inst.components.deployable:SetDeploySpacing(DEPLOYSPACING.NONE)

    return inst
end

return Prefab("tbat_pathway_slab", fn, assets, prefabs),
    Prefab("tbat_pathway_slab_item", itemfn, assets, prefabs_item),
    MakePlacer("tbat_pathway_slab_item_placer", "tbat_pathway_slab", "tbat_pathway_slab", "idle", true, nil, nil, nil, -90),
    MakePlacer("tbat_pathway_slab_item_skin1_placer", "tbat_pathway_slab_skin1", "tbat_pathway_slab_skin1", "idle", true, nil, nil, nil, -90),
    MakePlacer("tbat_pathway_slab_item_skin2_placer", "tbat_pathway_slab_skin2", "tbat_pathway_slab_skin2", "idle", true, nil, nil, nil, -90),
    MakePlacer("tbat_pathway_slab_item_skin3_placer", "tbat_pathway_slab_skin3", "tbat_pathway_slab_skin3", "idle", true, nil, nil, nil, -90)
