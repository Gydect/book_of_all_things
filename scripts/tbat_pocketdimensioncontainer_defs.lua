local POCKETDIMENSIONCONTAINER_DEFS = require("prefabs/pocketdimensioncontainer_defs").POCKETDIMENSIONCONTAINER_DEFS

local TBAT_POCKETDIMENSIONCONTAINER_DEFS = {
    {
        name = "tbat_rose_twin_goose",
        prefab = "tbat_rose_twin_goose_container",
        ui = "anim/ui_tbat_rose_twin_goose_12x5.zip",
        widgetname = "tbat_rose_twin_goose",
    },
    {
        name = "tbat_rose_twin_goose_wall",
        prefab = "tbat_rose_twin_goose_wall_container",
        ui = "anim/ui_tbat_rose_twin_goose_12x5.zip",
        widgetname = "tbat_rose_twin_goose_wall",
    },
    {
        name = "tbat_rose_twin_goose_fence",
        prefab = "tbat_rose_twin_goose_fence_container",
        ui = "anim/ui_tbat_rose_twin_goose_12x5.zip",
        widgetname = "tbat_rose_twin_goose_fence",
    },
    {
        name = "tbat_rose_twin_goose_plantable",
        prefab = "tbat_rose_twin_goose_plantable_container",
        ui = "anim/ui_tbat_rose_twin_goose_12x5.zip",
        widgetname = "tbat_rose_twin_goose_plantable",
    },
    {
        name = "tbat_rose_twin_goose_miscellaneous",
        prefab = "tbat_rose_twin_goose_miscellaneous_container",
        ui = "anim/ui_tbat_rose_twin_goose_12x5.zip",
        widgetname = "tbat_rose_twin_goose_miscellaneous",
    },
    {
        name = "tbat_rose_twin_goose_material",
        prefab = "tbat_rose_twin_goose_material_container",
        ui = "anim/ui_tbat_rose_twin_goose_12x5.zip",
        widgetname = "tbat_rose_twin_goose_material",
    },
    {
        name = "tbat_rose_twin_goose_decorate",
        prefab = "tbat_rose_twin_goose_decorate_container",
        ui = "anim/ui_tbat_rose_twin_goose_12x5.zip",
        widgetname = "tbat_rose_twin_goose_decorate",
    },
}

for _, v in ipairs(TBAT_POCKETDIMENSIONCONTAINER_DEFS) do
    table.insert(POCKETDIMENSIONCONTAINER_DEFS, v)
end