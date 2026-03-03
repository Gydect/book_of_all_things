-- ==================================================
-- [冒险家笔记界面相关代码，参照官方的格式编写]
-- ==================================================
AddPopup("ADVENTURERSNOTESSCREEN")

POPUPS.ADVENTURERSNOTESSCREEN.fn = function(inst, show)
    if inst.HUD then
        if not show then
            inst.HUD:CloseAdventurersNotesScreen()
        elseif not inst.HUD:OpenAdventurersNotesScreen() then
            POPUPS.ADVENTURERSNOTESSCREEN:Close(inst)
        end
    end
end

local PlayerHud = require("screens/playerhud")

function PlayerHud:OpenAdventurersNotesScreen()
    self:CloseAdventurersNotesScreen()
    local AdventurersNotesScreen = require("screens/tbat_adventurers_notes_screen")
    self.adventurersnotesscreen = AdventurersNotesScreen(self.owner)
    self:OpenScreenUnderPause(self.adventurersnotesscreen)
    return true
end

function PlayerHud:CloseAdventurersNotesScreen()
    if self.adventurersnotesscreen ~= nil then
        if self.adventurersnotesscreen.inst:IsValid() then
            TheFrontEnd:PopScreen(self.adventurersnotesscreen)
        end
        self.adventurersnotesscreen = nil
    end
end
