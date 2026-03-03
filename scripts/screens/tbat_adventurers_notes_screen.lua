local ScreenWidget = require "widgets/screen"
local Widget = require "widgets/widget"
local ImageButton = require "widgets/imagebutton"
local Text = require "widgets/text"
local Image = require "widgets/image"

local AdventurersNotesScreen = Class(ScreenWidget, function(self, owner)
    ScreenWidget._ctor(self, "AdventurersNotesScreen")

    self.owner = owner

    local black = self:AddChild(ImageButton("images/global.xml", "square.tex"))
    black.image:SetVRegPoint(ANCHOR_MIDDLE)
    black.image:SetHRegPoint(ANCHOR_MIDDLE)
    black.image:SetVAnchor(ANCHOR_MIDDLE)
    black.image:SetHAnchor(ANCHOR_MIDDLE)
    black.image:SetScaleMode(SCALEMODE_FILLSCREEN)
    black.image:SetTint(0, 0, 0, .5)
    black:SetOnClick(function() TheFrontEnd:PopScreen() end)
    black:SetHelpTextMessage("")

    self.proot = self:AddChild(Widget("ROOT"))
    self.proot:SetScaleMode(SCALEMODE_PROPORTIONAL) -- 保证界面在不同分辨率下看起来一致
    self.proot:SetHAnchor(ANCHOR_MIDDLE)            -- 界面水平居中
    self.proot:SetVAnchor(ANCHOR_MIDDLE)            -- 界面垂直居中
    self.proot:SetPosition(0, 50, 0)                -- 遵照旧mod的参数

    -- 设置背景
    self.bg = self.proot:AddChild(Image("images/tbat_ui.xml", "note_background.tex"))
    self.bg:SetScale(0.45, 0.45, 0.45) -- 遵照旧mod的参数

    self.button_close = self.proot:AddChild(ImageButton("images/tbat_ui.xml", "note_button_close.tex",
        "note_button_close.tex", "note_button_close.tex", "note_button_close.tex"))
    self.button_close:SetScale(0.45, 0.45, 0.45) -- 遵照旧mod的参数
    self.button_close:SetOnClick(function() TheFrontEnd:PopScreen() end)
    self.button_close:SetPosition(270, 234, 0)

    -- 设置界面文本
    self.title_text = self.proot:AddChild(Text(HEADERFONT, 28))
    self.title_text:SetString("冒险家笔记")
    self.title_text:SetColour(0, 0, 0, 1)
    self.title_text:SetPosition(-110, 140, 0)

    self.note_text = self.proot:AddChild(self:BuildNoteText(
        "　　自从有了翠羽鸟的陪伴，永恒大陆似乎也不那么乏味了。又是新的一天，收拾完物资，看向月晷——又是一个月圆之夜。我拿着星杖和石墙来到早就标记好的月台，太阳光逐渐隐没，我搓搓小手，准备将星杖插上月台。正是这时，我却发现不远处飘来了绿油油的星光。这是……荧光虫？不对，好奇心驱使我顺着光点向森林深处探索。走了不久，一座头顶四叶草、挥舞着翅膀的白鹤闯进我的视线。好熟悉的模样，我好像在那棵大树上见过它……它是万物书里的生物？我疑惑地摸了摸这座雕像。没有呼吸，也没有温度……它怎么看都不算在生物的范畴里吧！突然，一道微弱的光芒从我的背包里射向了雕像，是翠羽鸟羽毛！它微微颤抖，似乎是想要靠近雕像。翠羽鸟羽毛融入了雕像中，顷刻间，雕像通透的身体被绿色星光所缠绕，翠羽鸟羽毛竟然唤醒了雕像！"
    ))
    self.note_text:SetPosition(0, -75, 0)

    self.default_focus = self.bg
    SetAutopaused(true) -- 若单人玩家开了自动暂停,开启界面时会自动暂停游戏
end)

function AdventurersNotesScreen:OnDestroy()
    SetAutopaused(false)

    POPUPS.ADVENTURERSNOTESSCREEN:Close(self.owner)

    AdventurersNotesScreen._base.OnDestroy(self)
end

-- 笔记文本构建函数
function AdventurersNotesScreen:BuildNoteText(hint)
    local w = Widget("note_text_root")
    local note_text = w:AddChild(Text(HEADERFONT, 24))
    note_text:SetHAlign(ANCHOR_LEFT)
    note_text:SetVAlign(ANCHOR_TOP)
    note_text:SetRegionSize(350, 360)
    note_text:EnableWordWrap(true)
    note_text:SetColour(0, 0, 0, 1)
    note_text:SetString(hint or "No Data")
    note_text:SetPosition(0, 0)
    return w
end

return AdventurersNotesScreen
