local CONTENT = require "widgets/atbook_wikiwidget_defs"
CONTENT.SKIN[3][#CONTENT.SKIN[3] + 1] = {
    skincode = "tbat_vine_current",
    name = "洋流绳索",
    type = "",
    anim = "idle",
    height = 10,
    scale = 0.1,
    quality = "PURPLE",
    desc = "悬挂着海星、贝壳、船锚、漂流瓶与羽毛的绳索，是水手带回大海的声音。洋流在绳索上留下风蚀的痕迹,贝壳中藏着的是守护远行者的光",

    -- 我的额外补充
    new_mod = true,
    atlas = "images/tbat_inventoryimages.xml",
    image = "tbat_vine_current", -- 不用tex
    bank = "tbat_vine_current",
    build = "tbat_vine_current",
    prefabname = STRINGS.NAMES.TBAT_VINE_ROSE,
}
CONTENT.SKIN[3][#CONTENT.SKIN[3] + 1] = {
    skincode = "tbat_vine_dreamcatcher",
    name = "捕梦花绳",
    type = "",
    anim = "idle",
    height = 10,
    scale = 0.1,
    quality = "PURPLE",
    desc = "它仿佛不是被编织出来的，而是从一场春夜的梦里缓缓落下，像森林在夜色中低声吟唱。",

    -- 我的额外补充
    new_mod = true,
    atlas = "images/tbat_inventoryimages.xml",
    image = "tbat_vine_dreamcatcher", -- 不用tex
    bank = "tbat_vine_dreamcatcher",
    build = "tbat_vine_dreamcatcher",
    prefabname = STRINGS.NAMES.TBAT_VINE_ROSE,
}

return CONTENT
