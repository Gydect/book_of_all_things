-- 关闭容器
AddModRPCHandler("BOOKOFALLTHINGS", "Closecontainer", function(player, container)
    if container.components.container:IsOpenedBy(player) then
        container.components.container:Close(player)
        player:PushEvent("closecontainer", { container = container })
    end
end)

AddModRPCHandler("BOOKOFALLTHINGS", "Changecontainer", function(operate_player, container, container_name)
    if container.components.container:IsOpenedBy(operate_player) then
        local other_container = container.tbat_openlist[operate_player]
        if other_container == nil then
            return
        end
        for player, open_container in pairs(container.tbat_openlist) do
            if open_container == other_container then
                container.components.container:Close(player)
                player:PushEvent("closecontainer", { container = container })
                other_container.components.container_proxy:SetMaster(TheWorld:GetPocketDimensionContainer(container_name))
                other_container.components.container_proxy:Open(player)
                player:PushEvent("opencontainer", { container = other_container.components.container_proxy:GetMaster() })
            end
        end
    end
end)

local function add(item, needed_count)
    if item.components.finiteuses then
        local now_percent = item.components.finiteuses:GetPercent()
        local new_percent = math.min(3, now_percent + 0.2)
        item.components.finiteuses:SetPercent(new_percent)
    elseif item.components.armor then
        local now_percent = item.components.armor:GetPercent()
        local new_percent = math.min(3, now_percent + 0.2)
        item.components.armor:SetPercent(new_percent)
    elseif item.prefab == "tbat_material_lavender_laundry_detergent" then
        item.components.stackable:Get(needed_count):Remove()
    end
end

local function reduce(item, needed_count)
    if item.components.finiteuses then
        local now_percent = item.components.finiteuses:GetPercent()
        local new_percent = math.max(0, now_percent - 0.2)
        item.components.finiteuses:SetPercent(new_percent)
    elseif item.components.armor then
        local now_percent = item.components.armor:GetPercent()
        local new_percent = math.max(0, now_percent - 0.2)
        item.components.armor:SetPercent(new_percent)
    elseif item.prefab == "tbat_material_lavender_laundry_detergent" then
        item.components.stackable:Get(needed_count):Remove()
    end
end

AddModRPCHandler("BOOKOFALLTHINGS", "UsePetWasher", function(player, container, status)
    if container.components.container:IsOpenedBy(player) then
        container.components.container:Close(player)
        player:PushEvent("closecontainer", { container = container })
    end
    local ok, count = container.components.container:Has("tbat_material_lavender_laundry_detergent", 5)
    if not ok then
        return
    end
    local num_items = container.components.container:NumItems() - 1
    local needed_count = num_items * 5
    if count < needed_count then
        return
    end
    if status == "add" then
        container.components.container:ForEachItem(add, needed_count)
    elseif status == "reduce" then
        container.components.container:ForEachItem(reduce, needed_count)
    end
end)
