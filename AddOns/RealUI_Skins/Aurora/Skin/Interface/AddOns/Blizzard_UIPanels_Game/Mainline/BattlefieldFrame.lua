local _, private = ...
if private.shouldSkip() then return end

--[[ Lua Globals ]]
-- luacheck: globals

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin

local function SetAllTextWhite(frame)
    if not frame or not frame.GetNumRegions then return end
    for i = 1, frame:GetNumRegions() do
        local region = _G.select(i, frame:GetRegions())
        if region and region.GetObjectType and region:GetObjectType() == "FontString" then
            region:SetTextColor(1, 1, 1)
        end
    end
end

local function ApplySkin()
    local BattlefieldFrame = _G.BattlefieldFrame
    if not BattlefieldFrame or BattlefieldFrame._auroraSkinned then return end
    BattlefieldFrame._auroraSkinned = true

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

    local scrollFrame = _G.BattlefieldListScrollFrame or BattlefieldFrame.ScrollFrame
    if scrollFrame then
        Skin.UIPanelScrollFrameTemplate(scrollFrame)
        if scrollFrame.ScrollChild then
            SetAllTextWhite(scrollFrame.ScrollChild)
        end
    end

    local typeDropDown = _G.BattlefieldFrameTypeDropDown or BattlefieldFrame.TypeDropDown
    if typeDropDown and Skin.UIDropDownMenuTemplate then
        Skin.UIDropDownMenuTemplate(typeDropDown)
    end

    local buttons = {
        _G.BattlefieldFrameJoinButton,
        _G.BattlefieldFrameJoinBattleButton,
        _G.BattlefieldFrameCancelButton,
        _G.BattlefieldFrameLeaveButton,
        _G.BattlefieldFrameGroupJoinButton,
    }
    for _, button in next, buttons do
        if button then
            Skin.UIPanelButtonTemplate(button)
        end
    end

    SetAllTextWhite(BattlefieldFrame)
end

function private.FrameXML.BattlefieldFrame()
    if _G.BattlefieldFrame then
        ApplySkin()
        _G.BattlefieldFrame:HookScript("OnShow", ApplySkin)
    elseif type(_G.BattlefieldFrame_OnLoad) == "function" then
        _G.hooksecurefunc("BattlefieldFrame_OnLoad", ApplySkin)
    end
end
