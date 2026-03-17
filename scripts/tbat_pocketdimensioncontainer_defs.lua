local POCKETDIMENSIONCONTAINER_DEFS = require("prefabs/pocketdimensioncontainer_defs").POCKETDIMENSIONCONTAINER_DEFS

local TBAT_POCKETDIMENSIONCONTAINER_DEFS = {
    {
        name = "tbat_rose_twin_goose",
        prefab = "tbat_rose_twin_goose_container",
        ui = "anim/ui_tbat_rose_twin_goose_12x5.zip",
        widgetname = "tbat_rose_twin_goose",
    },
}

for _, v in ipairs(TBAT_POCKETDIMENSIONCONTAINER_DEFS) do
    table.insert(POCKETDIMENSIONCONTAINER_DEFS, v)
end