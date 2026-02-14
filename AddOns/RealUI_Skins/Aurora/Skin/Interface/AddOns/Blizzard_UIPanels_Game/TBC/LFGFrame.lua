local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select hooksecurefunc

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

-- Helper to hide ONLY border/background textures by texture path
local function StripBorderTextures(frame)
    if not frame then return end
    for i = 1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())
        if region and region:IsObjectType("Texture") then
            local texturePath = region:GetTexture()
            if texturePath and type(texturePath) == "string" then
                local lowerPath = texturePath:lower()
                if lowerPath:find("border") or
                   lowerPath:find("background") or
                   lowerPath:find("edge") or
                   lowerPath:find("corner") or
                   lowerPath:find("dialogframe") or
                   lowerPath:find("ui%-panel") then
                    region:SetTexture("")
                    region:SetAlpha(0)
                end
            end
        end
    end
end

-- Helper to hide a frame/texture by name or property
local function HideElement(parent, name)
    local element = parent[name] or _G[name]
    if element then
        if element.SetTexture then
            element:SetTexture("")
        end
        if element.SetAlpha then
            element:SetAlpha(0)
        end
        if element.Hide then
            element:Hide()
        end
    end
end

-- Recolor text for readability
local function RecolorFrameText(frame)
    if not frame then return end

    for i = 1, frame:GetNumRegions() do
        local region = select(i, frame:GetRegions())
        if region and region:IsObjectType("FontString") then
            region:SetTextColor(1, 1, 1)
        end
    end

    -- Also check children
    for _, child in pairs({frame:GetChildren()}) do
        if child.GetNumRegions then
            for i = 1, child:GetNumRegions() do
                local region = select(i, child:GetRegions())
                if region and region:IsObjectType("FontString") then
                    region:SetTextColor(1, 1, 1)
                end
            end
        end
    end
end

-- Track skinned state
local lfgSkinned = false

local function SkinLFGFrames()
    if lfgSkinned then return end

    -- =============================================================================
    -- TBCC Anniversary LFG Frame (LFGParentFrame)
    -- =============================================================================
    local LFGParentFrame = _G.LFGParentFrame
    if LFGParentFrame then
        lfgSkinned = true

        -- Strip only border textures, keep content
        StripBorderTextures(LFGParentFrame)

        -- Hide specific named elements
        HideElement(_G, "LFGParentFramePortrait")
        HideElement(_G, "LFGParentFramePortraitFrame")
        HideElement(LFGParentFrame, "Bg")
        HideElement(LFGParentFrame, "TitleBg")

        -- Apply Aurora backdrop
        Base.SetBackdrop(LFGParentFrame, Color.frame)

        -- Skin close button
        local closeButton = LFGParentFrame.CloseButton or _G.LFGParentFrameCloseButton
        if closeButton then
            if Skin.UIPanelCloseButton then
                Skin.UIPanelCloseButton(closeButton)
            else
                Skin.FrameTypeButton(closeButton)
            end
        end

        -- Skin bottom tabs (Create Listing / Group Browser)
        for i = 1, 3 do
            local tab = _G["LFGParentFrameTab"..i]
            if tab then
                -- Only strip border textures from tabs
                StripBorderTextures(tab)

                -- Apply button skin
                Skin.FrameTypeButton(tab)

                -- Make sure tab text is visible
                local tabText = tab:GetFontString()
                if tabText then
                    tabText:SetTextColor(1, 1, 1)
                end
            end
        end

        -- Skin LFG Browse Frame (list of groups)
        local LFGBrowseFrame = _G.LFGBrowseFrame
        if LFGBrowseFrame then
            StripBorderTextures(LFGBrowseFrame)
        end

        -- Skin LFM Frame (looking for more)
        local LFMFrame = _G.LFMFrame
        if LFMFrame then
            StripBorderTextures(LFMFrame)
        end

        -- Skin category buttons (Dungeons, Quests & Zones, etc.)
        for i = 1, 10 do
            local catButton = _G["LFGListFrameButton"..i]
            if catButton then
                Skin.FrameTypeButton(catButton)
            end
        end

        -- Skin Back/List Self buttons
        local backBtn = _G.LFGBackButton or _G.LFGBrowseFrameBackButton
        if backBtn then
            Skin.FrameTypeButton(backBtn)
        end

        local listSelfBtn = _G.LFGListSelfButton or _G.LFGBrowseFrameListSelfButton
        if listSelfBtn then
            Skin.FrameTypeButton(listSelfBtn)
        end

        -- Hook for text recoloring
        local function DelayedRecolor()
            _G.C_Timer.After(0, function()
                RecolorFrameText(LFGParentFrame)

                -- Title text
                local titleText = _G.LFGParentFrameTitleText
                if titleText and titleText.SetTextColor then
                    titleText:SetTextColor(1, 1, 1)
                end
            end)
        end

        LFGParentFrame:HookScript("OnShow", DelayedRecolor)
        DelayedRecolor()
    end

    -- =============================================================================
    -- Alternative: LFGListFrame (if different from LFGParentFrame)
    -- =============================================================================
    local LFGListFrame = _G.LFGListFrame
    if LFGListFrame and LFGListFrame ~= LFGParentFrame then
        lfgSkinned = true

        StripBorderTextures(LFGListFrame)
        Base.SetBackdrop(LFGListFrame, Color.frame)

        local closeButton = LFGListFrame.CloseButton or _G.LFGListFrameCloseButton
        if closeButton then
            if Skin.UIPanelCloseButton then
                Skin.UIPanelCloseButton(closeButton)
            else
                Skin.FrameTypeButton(closeButton)
            end
        end
    end

    -- =============================================================================
    -- PVEFrame (Retail-style, may exist in some versions)
    -- =============================================================================
    local PVEFrame = _G.PVEFrame
    if PVEFrame then
        lfgSkinned = true

        StripBorderTextures(PVEFrame)
        HideElement(_G, "PVEFramePortrait")
        HideElement(PVEFrame, "Bg")
        HideElement(PVEFrame, "TitleBg")

        Base.SetBackdrop(PVEFrame, Color.frame)

        local closeButton = PVEFrame.CloseButton or _G.PVEFrameCloseButton
        if closeButton then
            if Skin.UIPanelCloseButton then
                Skin.UIPanelCloseButton(closeButton)
            else
                Skin.FrameTypeButton(closeButton)
            end
        end

        -- Skin tabs
        for i = 1, 4 do
            local tab = PVEFrame["tab"..i] or _G["PVEFrameTab"..i]
            if tab then
                StripBorderTextures(tab)
                Skin.FrameTypeButton(tab)
            end
        end

        local function DelayedRecolor()
            _G.C_Timer.After(0, function() RecolorFrameText(PVEFrame) end)
        end

        PVEFrame:HookScript("OnShow", DelayedRecolor)
        DelayedRecolor()
    end
end

-- Entry point called by Aurora
function private.FrameXML.LFGFrame()
    -- Try to skin immediately
    SkinLFGFrames()

    -- If not skinned, watch for frame creation
    if not lfgSkinned then
        local watcher = _G.CreateFrame("Frame")
        watcher:RegisterEvent("ADDON_LOADED")
        watcher:RegisterEvent("PLAYER_ENTERING_WORLD")
        watcher:SetScript("OnEvent", function(self, event, addon)
            if addon == "Blizzard_LookingForGroupUI" or
               addon == "Blizzard_GroupFinder" or
               event == "PLAYER_ENTERING_WORLD" then
                SkinLFGFrames()
                if lfgSkinned then
                    self:UnregisterAllEvents()
                end
            end
        end)

        -- Delayed attempts
        _G.C_Timer.After(1, SkinLFGFrames)
        _G.C_Timer.After(3, SkinLFGFrames)
    end
end
