-- 科雷动作失败触发台词优先级错误,除了威尔逊以外的原版角色,优先触发 character_tbl.ACTIONFAIL_GENERIC 台词
-- 应该让 getcharacterstring(STRINGS.CHARACTERS.GENERIC.ACTIONFAIL, action, reason) 优先于 character_tbl.ACTIONFAIL_GENERIC 触发
local function getmodifiedstring(topic_tab, modifier)
    if type(modifier) == "table" then
        local ret = topic_tab
        for i, v in ipairs(modifier) do
            if ret == nil then
                return nil
            end
            ret = ret[v]
        end
        return ret
    elseif modifier ~= nil then
        local ret = topic_tab[modifier]
        return (type(ret) == "table" and #ret > 0 and ret[math.random(#ret)])
            or ret
            or topic_tab.GENERIC
            or (#topic_tab > 0 and topic_tab[math.random(#topic_tab)])
            or nil
    else
        return topic_tab.GENERIC
            or (#topic_tab > 0 and topic_tab[math.random(#topic_tab)])
            or nil
    end
end

local function getcharacterstring(tab, item, modifier)
    if tab == nil then
        return
    end

    local topic_tab = tab[item]
    if topic_tab == nil then
        return
    elseif type(topic_tab) == "string" then
        return topic_tab
    elseif type(topic_tab) ~= "table" then
        return
    end

    if type(modifier) == "table" then
        for i, v in ipairs(modifier) do
            v = string.upper(v)
        end
    else
        modifier = modifier ~= nil and string.upper(modifier) or nil
    end

    return getmodifiedstring(topic_tab, modifier)
end

local function GetActionFailString(inst, action, reason)
    local character =
        type(inst) == "string"
        and inst
        or (inst ~= nil and inst.prefab or nil)

    local specialcharacter =
        type(inst) == "table"
        and ((inst:HasTag("playerghost") and "ghost") or
            (inst:HasTag("mime") and "mime"))
        or character

    local ret = GetSpecialCharacterString(specialcharacter)
    if ret ~= nil then
        return ret
    end

    character = string.upper(character)

    local character_tbl = STRINGS.CHARACTERS[character]
    return character_tbl
        and (getcharacterstring(character_tbl.ACTIONFAIL, action, reason) or
            getcharacterstring(character_tbl.ACTIONFAIL, "GENERIC", reason)
        )
        or getcharacterstring(STRINGS.CHARACTERS.GENERIC.ACTIONFAIL, action, reason)
        or getcharacterstring(STRINGS.CHARACTERS.GENERIC.ACTIONFAIL, "GENERIC", reason)
        or (character_tbl and character_tbl.ACTIONFAIL_GENERIC)
        or STRINGS.CHARACTERS.GENERIC.ACTIONFAIL_GENERIC
end
GLOBAL.GetActionFailString = GetActionFailString
