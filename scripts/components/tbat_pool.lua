-- 幻灵水池组件,目前仅打捞功能
local TbatPool = Class(function(self, inst)
    self.inst = inst

    self.salvagefn = nil
    self.salvageonceperday = {}
end)

function TbatPool:SetSalvageFn(fn)
    self.salvagefn = fn
end

local function GetTodayCycle()
    return TheWorld ~= nil and TheWorld.state ~= nil and TheWorld.state.cycles or 0
end

local function GetDoerKey(doer)
    if doer == nil then
        return nil
    end
    return doer.userid or tostring(doer.GUID)
end

function TbatPool:CanSalvage(doer)
    local key = GetDoerKey(doer)
    if key == nil then
        return false
    end
    return self.salvageonceperday[key] ~= GetTodayCycle()
end

function TbatPool:MarkSalvaged(doer)
    local key = GetDoerKey(doer)
    if key ~= nil then
        self.salvageonceperday[key] = GetTodayCycle()
    end
end

function TbatPool:Salvage(doer)
    if not self:CanSalvage(doer) then
        return false, "ALREADY_SALVAGED_TODAY"
    end

    if self.salvagefn == nil then
        return false
    end

    local success, reason = self.salvagefn(self.inst, doer)
    if success then
        self:MarkSalvaged(doer)
    end
    return success, reason
end

function TbatPool:OnSave()
    return {
        salvageonceperday = self.salvageonceperday,
    }
end

function TbatPool:OnLoad(data)
    if data ~= nil and data.salvageonceperday ~= nil then
        self.salvageonceperday = data.salvageonceperday
    end
end

return TbatPool
