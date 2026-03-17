-- 关闭容器
AddModRPCHandler("BOOKOFALLTHINGS", "Closecontainer", function(player, container)
    if container.components.container:IsOpenedBy(player) then
        container.components.container:Close(player)
        player:PushEvent("closecontainer", { container = container })
    end
end)
