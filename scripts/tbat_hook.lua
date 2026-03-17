-- ================================================================
--[[给幻灵水池容器做特殊处理,实现特殊槽位多slots]]
-- ================================================================
local TARGET_CONTAINER_PREFAB = "tbat_spirit_pool" -- 仅干预自己mod的容器,避免和其他mod冲突

local function IsTargetContainer(self, item)
    return self.inst ~= nil
        and self.inst.prefab == TARGET_CONTAINER_PREFAB
end

local function GetStackable(item)
    if item == nil then
        return nil
    end

    return (item.components ~= nil and item.components.stackable)
        or (item.replica ~= nil and item.replica.stackable)
        or nil
end

local function FindFirstAvailableSpecificSlot(self, item)
    local empty_slot = nil

    for i = 1, self:GetNumSlots() do
        if self:itemtestfn(item, i) then
            local slot_item = self:GetItemInSlot(i)
            if slot_item == nil then
                empty_slot = empty_slot or i
            elseif self:AcceptsStacks()
                and slot_item.prefab == item.prefab
                and slot_item.skinname == item.skinname then
                local stackable = GetStackable(slot_item)
                if stackable ~= nil and not stackable:IsFull() then
                    return i
                end
            end
        end
    end

    return empty_slot
end

local Container = require("components/container")
if not Container._tbat_specific_slot_hooked then
    Container._tbat_specific_slot_hooked = true

    local _GetSpecificSlotForItem = Container.GetSpecificSlotForItem
    function Container:GetSpecificSlotForItem(item, ...)
        if not IsTargetContainer(self, item) then
            return _GetSpecificSlotForItem(self, item, ...)
        end

        return FindFirstAvailableSpecificSlot(self, item)
    end
end

local ContainerReplica = require("components/container_replica")
if not ContainerReplica._tbat_specific_slot_hooked then
    ContainerReplica._tbat_specific_slot_hooked = true

    local _GetSpecificSlotForItem = ContainerReplica.GetSpecificSlotForItem
    function ContainerReplica:GetSpecificSlotForItem(item, ...)
        if not IsTargetContainer(self, item) then
            return _GetSpecificSlotForItem(self, item, ...)
        end

        return FindFirstAvailableSpecificSlot(self, item)
    end
end

-- ================================================================
--[[给幻灵水池的鱼池组件做特殊处理]]
-- ================================================================
local Fishable = require("components/fishable")
local _HookFish = Fishable.HookFish
-- 剩余鱼数量始终在最大值
function Fishable:HookFish(fisherman, ...)
    if self.inst ~= nil and self.inst.prefab == TARGET_CONTAINER_PREFAB then
        -- 让幻灵水池的鱼池组件在被钓鱼杆钓到时也能正常工作
        local fish = _HookFish(self, fisherman, ...)
        if fish.build == nil then
            fish.build = "000"
        end
        self.fishleft = self.maxfish or 10
        return fish
    end

    return _HookFish(self, fisherman, ...)
end

-- ================================================================
--[[钓竿组件特殊处理，好复杂。。。]]
-- ================================================================
local FishingRod = require("components/fishingrod")
local _OnUpdate = FishingRod.OnUpdate
local _StopFishing = FishingRod.StopFishing
local _Hook = FishingRod.Hook
function FishingRod:OnUpdate(dt, ...)
    if self:IsFishing() and self.target and self.target.prefab == TARGET_CONTAINER_PREFAB then
        self.target.components.container.canbeopened = false
    end
    _OnUpdate(self, dt, ...)
end

function FishingRod:StopFishing(...)
    if self.target and self.target.prefab == TARGET_CONTAINER_PREFAB then
        self.target.components.container.canbeopened = true
    end
    _StopFishing(self, ...)
end

-- 这样多人钓鱼的时候应该不会彼此覆盖吧,有待实装验证
function FishingRod:Hook(...)
    self.target.tbat_fisherman = self.fisherman
    self.target.tbat_fishingrod = self.inst.prefab
    _Hook(self, ...)
    self.target.tbat_fisherman = nil
    self.target.tbat_fishingrod = nil
end

-- ================================================================
--[[冒险家笔记相关]]
-- ================================================================
-- 旧mod的逻辑可以直接用
local note_loot_old = {
    ["beequeen"] = { "tbat_item_notes_of_adventurer_2", "tbat_item_notes_of_adventurer_3" },
    ["dragonfly"] = { "tbat_item_notes_of_adventurer_4", "tbat_item_notes_of_adventurer_5" },
    ["bearger"] = { "tbat_item_notes_of_adventurer_6", "tbat_item_notes_of_adventurer_7", "tbat_item_notes_of_adventurer_8" },
    ["mutatedbearger"] = { "tbat_item_notes_of_adventurer_6", "tbat_item_notes_of_adventurer_7", "tbat_item_notes_of_adventurer_8" },
    ["klaus"] = { "tbat_item_notes_of_adventurer_9", "tbat_item_notes_of_adventurer_10" },
    ["deerclops"] = { "tbat_item_notes_of_adventurer_11", "tbat_item_notes_of_adventurer_12", "tbat_item_notes_of_adventurer_13", "tbat_item_notes_of_adventurer_14" },
    ["mutateddeerclops"] = { "tbat_item_notes_of_adventurer_11", "tbat_item_notes_of_adventurer_12", "tbat_item_notes_of_adventurer_13", "tbat_item_notes_of_adventurer_14" },
    ["antlion"] = { "tbat_item_notes_of_adventurer_15", "tbat_item_notes_of_adventurer_16" },
    ["eyeofterror"] = { "tbat_item_notes_of_adventurer_17", "tbat_item_notes_of_adventurer_18" },
    ["twinofterror1"] = { "tbat_item_notes_of_adventurer_17", "tbat_item_notes_of_adventurer_18" },
    ["twinofterror2"] = { "tbat_item_notes_of_adventurer_17", "tbat_item_notes_of_adventurer_18" },
    ["moose"] = { "tbat_item_notes_of_adventurer_19", "tbat_item_notes_of_adventurer_20" },
    ["daywalker2"] = { "tbat_item_notes_of_adventurer_21", "tbat_item_notes_of_adventurer_22", "tbat_item_notes_of_adventurer_23" },
}

local note_loot_new = {
    ["daywalker"] = { "tbat_item_notes_of_adventurer_24", "tbat_item_notes_of_adventurer_25" },
    ["toadstool"] = { "tbat_item_notes_of_adventurer_26", "tbat_item_notes_of_adventurer_27", "tbat_item_notes_of_adventurer_28" },
    ["toadstool_dark"] = { "tbat_item_notes_of_adventurer_26", "tbat_item_notes_of_adventurer_27", "tbat_item_notes_of_adventurer_28" },
    ["minotaur"] = { "tbat_item_notes_of_adventurer_29", "tbat_item_notes_of_adventurer_30", "tbat_item_notes_of_adventurer_31" },
    ["stalker_atrium"] = { "tbat_item_notes_of_adventurer_32", "tbat_item_notes_of_adventurer_33", "tbat_item_notes_of_adventurer_34" },
    ["sharkboi"] = { "tbat_item_notes_of_adventurer_35", "tbat_item_notes_of_adventurer_36" },
    ["malbatross"] = { "tbat_item_notes_of_adventurer_37", "tbat_item_notes_of_adventurer_38", "tbat_item_notes_of_adventurer_39" },
}

if not GLOBAL.BOOKOFEVERYTHING_SETS.ENABLEDMODS["old_tbat"] then
    for k, v in pairs(note_loot_old) do
        note_loot_new[k] = v
    end
end

note_loot_old = nil -- 释放旧表的内存占用

local function droploot(inst, data)
    local target = data and data.inst
    local prefab = target and target.prefab
    local ret = note_loot_new[prefab]
    if ret and target and target.components.lootdropper then
        local ret_prefab = ret[math.random(#ret)]
        target.components.lootdropper:SpawnLootPrefab(ret_prefab)
    end
end

AddPrefabPostInit("world", function(inst)
    if not TheWorld.ismastersim then
        return
    end

    TheWorld:ListenForEvent("entity_droploot", droploot)
end)

-- ================================================================
--[[容器UI相关改动]]
-- ================================================================
local ContainerWidget = require("widgets/containerwidget")
local _Open = ContainerWidget.Open
function ContainerWidget:Open(container, doer, ...)
    _Open(self, container, doer, ...)
    local widget = container.replica.container:GetWidget()
    if widget.buttoninfo ~= nil then
        self.button:SetTextures(
            widget.buttoninfo.atlas or "images/ui.xml",
            widget.buttoninfo.normal or "button_small.tex",
            widget.buttoninfo.focus or "button_small_over.tex",
            widget.buttoninfo.disabled or "button_small_disabled.tex",
            widget.buttoninfo.down or nil,
            widget.buttoninfo.selected or nil,
            widget.buttoninfo.scale or { 1, 1 },
            widget.buttoninfo.offset or { 0, 0 }
        )
    end
    self:Refresh()
end
