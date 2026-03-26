-- 晓光玫瑰藤蔓-2款权限皮肤
local vine_skins = {
    "current",
    "dreamcatcher",
}

for i, v in ipairs(vine_skins) do
    BOOKOFALLTHINGS.MakeItemSkinDefaultImage("tbat_vine_rose", "images/tbat_inventoryimages.xml", "tbat_vine_rose")
    BOOKOFALLTHINGS.MakeItemSkin(
        "tbat_vine_rose",
        "tbat_vine_" .. v,
        {
            name = STRINGS.TBAT_STRINGS["TBAT_VINE_" .. string.upper(v) .. "_NAME"],
            des = "None",
            rarity = "Spiffy",
            atlas = "images/tbat_inventoryimages.xml",
            image = "tbat_vine_" .. v,
            build = "tbat_vine_" .. v,
            bank = "tbat_vine_" .. v,
            basebuild = "tbat_vine_rose",
            basebank = "tbat_vine_rose",
            assets = {
                Asset("ANIM", "anim/tbat_vine_" .. v .. ".zip"),
            },
            checkfn = BOOKOFALLTHINGS.TbatSkinCheckFn,
            checkclientfn = BOOKOFALLTHINGS.TbatSkinCheckClientFn,
        }
    )
end
