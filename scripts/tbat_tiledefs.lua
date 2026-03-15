AddTile(
    "TBAT_FOREST",
    "LAND",
    { ground_name = "Tbat_forest" },
    {
        name = "carpet",
        noise_texture = "noise_tbat_forest",
        runsound = "dontstarve/movement/run_carpet",
        walksound = "dontstarve/movement/walk_carpet",
        snowsound = "dontstarve/movement/run_snow",
        mudsound = "dontstarve/movement/run_mud",
        flooring = true,
        hard = true,
    },
    {
        name = "map_edge",
        noise_texture = "noise_tbat_forest",
    },
    {
        name = "tbat_forest", -- 物品栏显示名称
        anim = "forest",      -- 地面动画
        bank_build = "tbat_turf",
        pickupsound = "cloth",
    }
)
