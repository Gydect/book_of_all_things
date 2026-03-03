local assets =
{
    Asset("ANIM", "anim/tbat_adventurers_notes.zip"),
}

local function OnReadBook(inst, doer)
    doer:ShowPopUp(POPUPS.ADVENTURERSNOTESSCREEN, true)
end

local function fn()
    local inst = CreateEntity()

    inst.entity:AddTransform()
    inst.entity:AddAnimState()
    inst.entity:AddSoundEmitter()
    inst.entity:AddNetwork()

    MakeInventoryPhysics(inst)

    inst.AnimState:SetBank("tbat_adventurers_notes")
    inst.AnimState:SetBuild("tbat_adventurers_notes")
    inst.AnimState:PlayAnimation("idle")

    inst:AddComponent("floater")
    inst.components.floater:SetSize("med")
    inst.components.floater:SetVerticalOffset(0.05)
    inst.components.floater:SetScale({ 0.85, 0.45, 0.85 }) -- 遵照旧mod的参数
    inst.components.floater.SwitchToFloatAnim = function(self, ...)
        self.inst.AnimState:PlayAnimation("idle_water")
    end
    inst.components.floater.SwitchToDefaultAnim = function(self, ...)
        self.inst.AnimState:PlayAnimation("idle")
    end

    inst:AddTag("tbat_note")

    inst.entity:SetPristine()

    if not TheWorld.ismastersim then
        return inst
    end

    -----------------------------------

    inst:AddComponent("inspectable")

    inst:AddComponent("inventoryitem")

    inst:AddComponent("tbat_note")
    inst.components.tbat_note.onreadfn = OnReadBook

    -- 可以当燃料但不能被引燃
    inst:AddComponent("fuel")
    inst.components.fuel.fuelvalue = TUNING.MED_FUEL

    MakeHauntableLaunch(inst)

    return inst
end

return Prefab("tbat_adventurers_notes", fn, assets, prefabs)
