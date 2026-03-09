-- 幻灵水池组件,目前仅打捞功能
local TbatPool = Class(function(self, inst)
    self.inst = inst

    self.salvagefn = nil
end)

function TbatPool:SetSalvageFn(fn)
    self.salvagefn = fn
end

function TbatPool:Salvage(doer)
    -- 实现打捞逻辑
    if self.salvagefn ~= nil then
        return self.salvagefn(self.inst, doer)
    else
        return false
    end
end

return TbatPool
