-- 幻灵水池组件,目前包含打捞和每日钓鱼次数功能
local FISHING_TIMES_PER_DAY = 20

local TbatPool = Class(function(self, inst)
    self.inst = inst

    self.salvagefn = nil
    self.salvageonceperday = {}
    self.fishingperday = {}
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

local function GetFishingData(self, doer)
    local key = GetDoerKey(doer)
    if key == nil then
        return nil
    end

    local today = GetTodayCycle()
    local data = self.fishingperday[key]
    if data == nil or data.day ~= today then
        data = {
            day = today,
            remaining = FISHING_TIMES_PER_DAY,
        }
        self.fishingperday[key] = data
    elseif data.remaining == nil then
        data.remaining = FISHING_TIMES_PER_DAY
    end

    return data
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

function TbatPool:CanFish(doer)
    local data = GetFishingData(self, doer)
    return data ~= nil and data.remaining > 0
end

function TbatPool:GetFishingRemaining(doer)
    local data = GetFishingData(self, doer)
    return data ~= nil and data.remaining or 0
end

function TbatPool:ConsumeFishingChance(doer)
    local data = GetFishingData(self, doer)
    if data == nil or data.remaining <= 0 then
        return false
    end

    data.remaining = math.max(0, data.remaining - 1)
    return true
end

function TbatPool:OnSave()
    return {
        salvageonceperday = self.salvageonceperday,
        fishingperday = self.fishingperday,
    }
end

function TbatPool:OnLoad(data)
    if data ~= nil and data.salvageonceperday ~= nil then
        self.salvageonceperday = data.salvageonceperday
    end
    if data ~= nil and data.fishingperday ~= nil then
        self.fishingperday = data.fishingperday
    end
end

return TbatPool
