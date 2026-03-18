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
