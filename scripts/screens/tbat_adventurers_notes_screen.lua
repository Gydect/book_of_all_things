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
    self.text = self.proot:AddChild(Text(HEADERFONT, 28))
    self.text:SetString("冒险家笔记")
    self.text:SetColour(0, 0, 0, 1)
    self.text:SetPosition(-110, 140, 0)

    self.default_focus = self.bg
    SetAutopaused(true) -- 若单人玩家开了自动暂停,开启界面时会自动暂停游戏
end)

function AdventurersNotesScreen:OnDestroy()
    SetAutopaused(false)

    POPUPS.ADVENTURERSNOTESSCREEN:Close(self.owner)

    AdventurersNotesScreen._base.OnDestroy(self)
end

return AdventurersNotesScreen
