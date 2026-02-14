local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select next

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

-- Helper to hide all textures in a frame
local function StripTextures(frame)
    if not frame then return end
    for i = 1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())
        if region and region:IsObjectType("Texture") then
            region:SetTexture("")
            region:SetAlpha(0)
            region:Hide()
        end
    end
end

-- Helper to recolor font strings for readability
local function RecolorFontStrings(frame)
    if not frame then return end
    for i = 1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())
        if region and region:IsObjectType("FontString") then
            region:SetTextColor(1, 1, 1)
        end
    end
end

-- Changed from private.AddOns.Blizzard_BattlefieldUI to private.FrameXML.BattlefieldFrame
-- because BattlefieldFrame is part of Blizzard_UIPanels_Game, not a separate addon
function private.FrameXML.BattlefieldFrame()
    local BattlefieldFrame = _G.BattlefieldFrame
    if not BattlefieldFrame then return end

    -- TBC: Manual texture hiding (Base.StripBlizzardTextures may use Retail-only APIs)
    StripTextures(BattlefieldFrame)

    -- Apply Aurora backdrop first
    Base.SetBackdrop(BattlefieldFrame, Color.frame)

    -- Also apply native TBC backdrop for reliability
    BattlefieldFrame:SetBackdrop({
        bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
        edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
        tile = true, tileEdge = true,
        tileSize = 16, edgeSize = 16,
        insets = { left = 4, right = 4, top = 4, bottom = 4 }
    })
    BattlefieldFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
    BattlefieldFrame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

    -- Hide portrait
    local portrait = _G.BattlefieldFramePortrait or BattlefieldFrame.Portrait
    if portrait then
        portrait:Hide()
    end

    local portraitFrame = _G.BattlefieldFramePortraitFrame
    if portraitFrame then
        portraitFrame:Hide()
    end

    -- Skin close button
    local closeButton = _G.BattlefieldFrameCloseButton or BattlefieldFrame.CloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin scroll frame
    local scrollFrame = _G.BattlefieldFrameScrollFrame or BattlefieldFrame.ScrollFrame
    if scrollFrame then
        StripTextures(scrollFrame)
    end

    -- Skin dropdown (if it exists)
    local typeDropDown = _G.BattlefieldFrameTypeDropDown or BattlefieldFrame.TypeDropDown
    if typeDropDown and Skin.UIDropDownMenuTemplate then
        Skin.UIDropDownMenuTemplate(typeDropDown)
    end

    -- Skin buttons
    local buttons = {
        _G.BattlefieldFrameJoinButton,
        _G.BattlefieldFrameCancelButton,
        _G.BattlefieldFrameLeaveButton,
        _G.BattlefieldFrameGroupJoinButton,
    }
    for _, button in next, buttons do
        if button then
            Skin.FrameTypeButton(button)
        end
    end

    -- Recolor font strings for readability on dark background
    RecolorFontStrings(BattlefieldFrame)

    -- Hook frame OnShow to reapply colors (in case Blizzard resets them)
    if BattlefieldFrame.OnShow then
        local originalOnShow = BattlefieldFrame:GetScript("OnShow")
        BattlefieldFrame:SetScript("OnShow", function(self)
            if originalOnShow then originalOnShow(self) end
            RecolorFontStrings(self)
        end)
    end

    -- Also skin BattlemasterFrame if it exists
    local BattlemasterFrame = _G.BattlemasterFrame
    if BattlemasterFrame then
        StripTextures(BattlemasterFrame)
        Base.SetBackdrop(BattlemasterFrame, Color.frame)

        -- Apply native TBC backdrop as insurance
        BattlemasterFrame:SetBackdrop({
            bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
            edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
            tile = true, tileEdge = true,
            tileSize = 16, edgeSize = 16,
            insets = { left = 4, right = 4, top = 4, bottom = 4 }
        })
        BattlemasterFrame:SetBackdropColor(0.1, 0.1, 0.1, 0.9)
        BattlemasterFrame:SetBackdropBorderColor(0.3, 0.3, 0.3, 1)

        local bmCloseButton = _G.BattlemasterFrameCloseButton or BattlemasterFrame.CloseButton
        if bmCloseButton then
            Skin.FrameTypeButton(bmCloseButton)
        end

        local bmButtons = {
            _G.BattlemasterFrameEnterButton,
            _G.BattlemasterFrameCancelButton,
        }
        for _, button in next, bmButtons do
            if button then
                Skin.FrameTypeButton(button)
            end
        end

        RecolorFontStrings(BattlemasterFrame)

        -- Hook OnShow to reapply colors
        if BattlemasterFrame.OnShow then
            local originalOnShow = BattlemasterFrame:GetScript("OnShow")
            BattlemasterFrame:SetScript("OnShow", function(self)
                if originalOnShow then originalOnShow(self) end
                RecolorFontStrings(self)
            end)
        end
    end
end
