local _G = GLOBAL
local containers = require("containers")
local params = {}

-- 兼容模组"Show Me (中文)"的容器列表
local showmeneed = {
    "tbat_spirit_pool",
}

-- ================================
--[[注册容器:幻灵水池]]
-- ================================
params.tbat_spirit_pool =
{
    widget =
    {
        slotpos = {
            Vector3(-68, 43, 0),
            Vector3(7, 43, 0),
            Vector3(82, 43, 0),
            Vector3(-68, -32, 0),
            Vector3(7, -32, 0),
            Vector3(82, -32, 0),
            Vector3(-68, -107, 0),
            Vector3(7, -107, 0),
            Vector3(82, -107, 0),
        },
        slotbg =
        {
            { image = "pool_slot_fish.tex", atlas = "images/tbat_hud.xml" },
            { image = "pool_slot_fish.tex", atlas = "images/tbat_hud.xml" },
            { image = "pool_slot_fish.tex", atlas = "images/tbat_hud.xml" },
            { image = "pool_slot_fish.tex", atlas = "images/tbat_hud.xml" },
            { image = "pool_slot_bait.tex", atlas = "images/tbat_hud.xml" },
            { image = "pool_slot_fish.tex", atlas = "images/tbat_hud.xml" },
            { image = "pool_slot_fish.tex", atlas = "images/tbat_hud.xml" },
            { image = "pool_slot_fish.tex", atlas = "images/tbat_hud.xml" },
            { image = "pool_slot_fish.tex", atlas = "images/tbat_hud.xml" },
        },
        animbank = "ui_tbat_spirit_pool_3x3",
        animbuild = "ui_tbat_spirit_pool_3x3",
        pos = Vector3(0, 200, 0), -- 容器默认坐标
        side_align_tip = 160,
        buttoninfo =
        {
            atlas = "images/tbat_hud.xml",
            normal = "spirit_pool_close_button.tex",
            focus = "spirit_pool_close_button.tex",
            disabled = "spirit_pool_close_button.tex",
            position = Vector3(189, 179, 0),
        },
    },
    type = "chest", -- 容器类型,可以自定义,不同的容器类型可以同时打开
    usespecificslotsforitems = true,
}

function params.tbat_spirit_pool.itemtestfn(container, item, slot)
    return (slot ~= 5 and (item:HasTag("smalloceancreature") or item:HasTag("fish"))) or
        (slot == 5 and item:HasTag("tbat_reef_conch")) or
        (slot == nil and (item:HasTag("smalloceancreature") or item:HasTag("tbat_reef_conch") or item:HasTag("fish")))
end

function params.tbat_spirit_pool.widget.buttoninfo.fn(inst, doer)
    if inst.components.container ~= nil then
        BufferedAction(doer, inst, ACTIONS.RUMMAGE):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendModRPCToServer(MOD_RPC.BOOKOFALLTHINGS.Closecontainer, inst)
    end
end

-- ================================
--[[注册容器:玫瑰双生鹅-1]]
-- ================================
params.tbat_rose_twin_goose =
{
    widget =
    {
        slotpos = {},
        slotbg = {},
        animbank = "ui_tbat_rose_twin_goose_12x5",
        animbuild = "ui_tbat_rose_twin_goose_12x5",
        pos = Vector3(0, 50, 0),
        side_align_tip = 160,
        buttoninfo =
        {
            atlas = "images/tbat_hud.xml",
            normal = "rose_twin_goose_close_button.tex",
            focus = "rose_twin_goose_close_button.tex",
            disabled = "rose_twin_goose_close_button.tex",
            position = Vector3(550, 190, 0),
        },
    },
    type = "chest",
}

local rose_twin_goose_bg = { image = "rose_twin_goose_slot.tex", atlas = "images/tbat_hud.xml" }

for y = 0, 4 do
    table.insert(params.tbat_rose_twin_goose.widget.slotpos, Vector3(-402 + 0 * 70, -70 * y + 106, 0))
    table.insert(params.tbat_rose_twin_goose.widget.slotpos, Vector3(-402 + 1 * 70, -70 * y + 106, 0))
    table.insert(params.tbat_rose_twin_goose.widget.slotpos, Vector3(-402 + 2 * 70, -70 * y + 106, 0))
    table.insert(params.tbat_rose_twin_goose.widget.slotpos, Vector3(-402 + 3 * 70, -70 * y + 106, 0))
end
for y = 0, 4 do
    table.insert(params.tbat_rose_twin_goose.widget.slotpos, Vector3(-82 + 0 * 70, -70 * y + 106, 0))
    table.insert(params.tbat_rose_twin_goose.widget.slotpos, Vector3(-82 + 1 * 70, -70 * y + 106, 0))
    table.insert(params.tbat_rose_twin_goose.widget.slotpos, Vector3(-82 + 2 * 70, -70 * y + 106, 0))
    table.insert(params.tbat_rose_twin_goose.widget.slotpos, Vector3(-82 + 3 * 70, -70 * y + 106, 0))
end
for y = 0, 4 do
    table.insert(params.tbat_rose_twin_goose.widget.slotpos, Vector3(238 + 0 * 70, -70 * y + 106, 0))
    table.insert(params.tbat_rose_twin_goose.widget.slotpos, Vector3(238 + 1 * 70, -70 * y + 106, 0))
    table.insert(params.tbat_rose_twin_goose.widget.slotpos, Vector3(238 + 2 * 70, -70 * y + 106, 0))
    table.insert(params.tbat_rose_twin_goose.widget.slotpos, Vector3(238 + 3 * 70, -70 * y + 106, 0))
end
for i = 1, 60 do
    table.insert(params.tbat_rose_twin_goose.widget.slotbg, rose_twin_goose_bg)
end
function params.tbat_rose_twin_goose.itemtestfn(container, item, slot)
    return not item:HasTag("irreplaceable")
end

function params.tbat_rose_twin_goose.widget.buttoninfo.fn(inst, doer)
    if inst.components.container ~= nil then
        BufferedAction(doer, inst, ACTIONS.RUMMAGE):Do()
    elseif inst.replica.container ~= nil and not inst.replica.container:IsBusy() then
        SendModRPCToServer(MOD_RPC.BOOKOFALLTHINGS.Closecontainer, inst)
    end
end

-- ================================
--[[修改容器注册函数]]
-- ================================
for k, v in pairs(params) do
    containers.params[k] = v

    -- 更新容器格子数量的最大值
    containers.MAXITEMSLOTS = math.max(containers.MAXITEMSLOTS, v.widget.slotpos ~= nil and #v.widget.slotpos or 0)
end

-- ================================
--[[mod兼容：Show Me (中文)]]
-- ================================
-- showme优先级如果比本mod高，那么这部分代码会生效
for k, mod in pairs(ModManager.mods) do
    if mod and _G.rawget(mod, "SHOWME_STRINGS") then -- showme特有的全局变量
        if
            mod.postinitfns and mod.postinitfns.PrefabPostInit and
            mod.postinitfns.PrefabPostInit.treasurechest
        then
            for _, v in ipairs(showmeneed) do
                mod.postinitfns.PrefabPostInit[v] = mod.postinitfns.PrefabPostInit.treasurechest
            end
        end
        break
    end
end

-- showme优先级如果比本mod低，那么这部分代码会生效
TUNING.MONITOR_CHESTS = TUNING.MONITOR_CHESTS or {}
for _, v in ipairs(showmeneed) do
    TUNING.MONITOR_CHESTS[v] = true
end

-- 释放内存
params = nil
showmeneed = nil
