local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

function private.AddOns.Blizzard_BattlefieldUI()
    local BattlefieldFrame = _G.BattlefieldFrame
    if not BattlefieldFrame then return end

    Base.StripBlizzardTextures(BattlefieldFrame)
    Skin.FrameTypeFrame(BattlefieldFrame)

    local portrait = _G.BattlefieldFramePortrait or BattlefieldFrame.Portrait
    if portrait then
        portrait:Hide()
    end
    local portraitFrame = _G.BattlefieldFramePortraitFrame
    if portraitFrame then
        portraitFrame:Hide()
    end

    local closeButton = _G.BattlefieldFrameCloseButton or BattlefieldFrame.CloseButton
    if closeButton then
        Skin.UIPanelCloseButton(closeButton)
    end

    local scrollFrame = _G.BattlefieldFrameScrollFrame or BattlefieldFrame.ScrollFrame
    if scrollFrame then
        Skin.UIPanelScrollFrameTemplate(scrollFrame)
    end

    local typeDropDown = _G.BattlefieldFrameTypeDropDown or BattlefieldFrame.TypeDropDown
    if typeDropDown and Skin.UIDropDownMenuTemplate then
        Skin.UIDropDownMenuTemplate(typeDropDown)
    end

    local buttons = {
        _G.BattlefieldFrameJoinButton,
        _G.BattlefieldFrameCancelButton,
        _G.BattlefieldFrameLeaveButton,
        _G.BattlefieldFrameGroupJoinButton,
    }
    for _, button in next, buttons do
        if button then
            Skin.UIPanelButtonTemplate(button)
        end
    end
end
