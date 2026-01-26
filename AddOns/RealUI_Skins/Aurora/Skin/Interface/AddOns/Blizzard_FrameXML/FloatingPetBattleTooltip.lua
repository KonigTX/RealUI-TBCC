local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Skin = Aurora.Skin

--do --[[ FrameXML\FloatingPetBattleTooltip.lua ]]
--end

do --[[ FrameXML\FloatingPetBattleTooltip.xml ]]
    function Skin.BattlePetTooltipTemplate(Frame)
        Skin.TooltipBorderedFrameTemplate(Frame)
    end
end

function private.FrameXML.FloatingPetBattleTooltip()
    if private.disabled.tooltips then return end

    if _G.FloatingPetBattleAbilityTooltip then
        Skin.SharedPetBattleAbilityTooltipTemplate(_G.FloatingPetBattleAbilityTooltip)
        if _G.FloatingPetBattleAbilityTooltip.CloseButton then
            Skin.UIPanelCloseButton(_G.FloatingPetBattleAbilityTooltip.CloseButton)
        end
    end

    if _G.FloatingBattlePetTooltip then
        Skin.BattlePetTooltipTemplate(_G.FloatingBattlePetTooltip)
        if _G.FloatingBattlePetTooltip.Delimiter then
            _G.FloatingBattlePetTooltip.Delimiter:SetHeight(1)
        end
        if _G.FloatingBattlePetTooltip.CloseButton then
            Skin.UIPanelCloseButton(_G.FloatingBattlePetTooltip.CloseButton)
        end
    end
end
