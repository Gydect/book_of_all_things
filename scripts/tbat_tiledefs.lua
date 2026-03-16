AddTile(
    "TBAT_SNOWFALL",
    "LAND",
    { ground_name = "Tbat_snowfall" },
    {
        name = "tbat_jungle_new",
        noise_texture = "noise_tbat_snowfall",
        runsound = "dontstarve/movement/run_grass",
        walksound = "dontstarve/movement/walk_grass",
        snowsound = "dontstarve/movement/run_snow",
        mudsound = "dontstarve/movement/run_mud",
        flooring = true,
    },
    {
        name = "map_edge",
        noise_texture = "noise_tbat_snowfall",
    },
    {
        name = "tbat_snowfall",
        anim = "snowfall",
        bank_build = "tbat_turf",
        pickupsound = "vegetation_grassy",
    }
)
ChangeTileRenderOrder(WORLD_TILES.TBAT_SNOWFALL, WORLD_TILES.MARSH)

AddTile(
    "TBAT_CLOUD",
    "LAND",
    { ground_name = "Tbat_cloud" },
    {
        name = "tbat_jungle_new",
        noise_texture = "noise_tbat_cloud",
        runsound = "dontstarve/movement/run_grass",
        walksound = "dontstarve/movement/walk_grass",
        snowsound = "dontstarve/movement/run_snow",
        mudsound = "dontstarve/movement/run_mud",
        flooring = true,
    },
    {
        name = "map_edge",
        noise_texture = "noise_tbat_cloud",
    },
    {
        name = "tbat_cloud",
        anim = "cloud",
        bank_build = "tbat_turf",
        pickupsound = "vegetation_grassy",
    }
)
ChangeTileRenderOrder(WORLD_TILES.TBAT_CLOUD, WORLD_TILES.SAVANNA)

AddTile(
    "TBAT_PSYLOCKE",
    "LAND",
    { ground_name = "Tbat_psylocke" },
    {
        name = "tbat_jungle_new",
        noise_texture = "noise_tbat_psylocke",
        runsound = "dontstarve/movement/run_grass",
        walksound = "dontstarve/movement/walk_grass",
        snowsound = "dontstarve/movement/run_snow",
        mudsound = "dontstarve/movement/run_mud",
        flooring = true,
    },
    {
        name = "map_edge",
        noise_texture = "noise_tbat_psylocke",
    },
    {
        name = "tbat_psylocke",
        anim = "psylocke",
        bank_build = "tbat_turf",
        pickupsound = "vegetation_grassy",
    }
)
ChangeTileRenderOrder(WORLD_TILES.TBAT_PSYLOCKE, WORLD_TILES.ROCKY)

AddTile(
    "TBAT_FOREST",
    "LAND",
    { ground_name = "Tbat_forest" },
    {
        name = "tbat_jungle_new",
        noise_texture = "noise_tbat_forest",
        runsound = "dontstarve/movement/run_grass",
        walksound = "dontstarve/movement/walk_grass",
        snowsound = "dontstarve/movement/run_snow",
        mudsound = "dontstarve/movement/run_mud",
        flooring = true,
    },
    {
        name = "map_edge",
        noise_texture = "noise_tbat_forest",
    },
    {
        name = "tbat_forest",
        anim = "forest",
        bank_build = "tbat_turf",
        pickupsound = "vegetation_grassy",
    }
)
ChangeTileRenderOrder(WORLD_TILES.TBAT_FOREST, WORLD_TILES.FOREST)
