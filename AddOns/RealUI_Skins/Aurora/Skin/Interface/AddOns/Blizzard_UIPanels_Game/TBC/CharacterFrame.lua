local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select ipairs

--[[ Core ]]
local Aurora = private.Aurora
local Base = Aurora.Base
local Skin = Aurora.Skin
local Color = Aurora.Color

-- Helper to hide all textures in a frame (excluding FontStrings)
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

-- Skin a tab button for TBCC
local function SkinTab(tab, index)
    if not tab then return end

    -- Hide tab textures (left, middle, right parts)
    local tabName = tab:GetName()
    if tabName then
        HideElement(_G, tabName.."Left")
        HideElement(_G, tabName.."LeftDisabled")
        HideElement(_G, tabName.."Middle")
        HideElement(_G, tabName.."MiddleDisabled")
        HideElement(_G, tabName.."Right")
        HideElement(_G, tabName.."RightDisabled")
    end

    -- Strip any remaining textures
    for i = 1, tab:GetNumRegions() do
        local region = select(i, tab:GetRegions())
        if region and region:IsObjectType("Texture") then
            region:SetTexture("")
            region:SetAlpha(0)
        end
    end

    -- Apply backdrop
    Base.SetBackdrop(tab, Color.button)

    -- Make sure text is visible (white/light color)
    local text = tab:GetFontString()
    if text then
        text:SetTextColor(1, 1, 1)
    end

    -- Position tabs properly - first tab anchors to frame, others chain
    tab:ClearAllPoints()
    if index == 1 then
        tab:SetPoint("TOPLEFT", _G.CharacterFrame, "BOTTOMLEFT", 5, 2)
    else
        local prevTab = _G["CharacterFrameTab"..(index-1)]
        if prevTab then
            tab:SetPoint("LEFT", prevTab, "RIGHT", 4, 0)
        end
    end

    -- Standardize tab size
    tab:SetHeight(24)
end

function private.FrameXML.CharacterFrame()
    local CharacterFrame = _G.CharacterFrame
    if not CharacterFrame then return end

    -- Hide NineSlice border system (TBCC uses this)
    if CharacterFrame.NineSlice then
        StripTextures(CharacterFrame.NineSlice)
        CharacterFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(CharacterFrame, "portrait")
    HideElement(CharacterFrame, "PortraitFrame")
    HideElement(CharacterFrame, "PortraitContainer")
    HideElement(_G, "CharacterFramePortrait")
    HideElement(_G, "CharacterFramePortraitFrame")

    -- Hide border edges (TBCC structure)
    HideElement(CharacterFrame, "TopEdge")
    HideElement(CharacterFrame, "BottomEdge")
    HideElement(CharacterFrame, "LeftEdge")
    HideElement(CharacterFrame, "RightEdge")
    HideElement(CharacterFrame, "TopLeftCorner")
    HideElement(CharacterFrame, "TopRightCorner")
    HideElement(CharacterFrame, "BottomLeftCorner")
    HideElement(CharacterFrame, "BottomRightCorner")
    HideElement(CharacterFrame, "Center")

    -- Hide named global textures (fallback)
    HideElement(_G, "CharacterFrameTopLeftCorner")
    HideElement(_G, "CharacterFrameTopRightCorner")
    HideElement(_G, "CharacterFrameBottomLeftCorner")
    HideElement(_G, "CharacterFrameBottomRightCorner")
    HideElement(_G, "CharacterFrameTopBorder")
    HideElement(_G, "CharacterFrameBottomBorder")
    HideElement(_G, "CharacterFrameLeftBorder")
    HideElement(_G, "CharacterFrameRightBorder")
    HideElement(_G, "CharacterFrameTopTileStreaks")

    -- Hide Bg and TitleBg
    HideElement(CharacterFrame, "Bg")
    HideElement(CharacterFrame, "TitleBg")
    HideElement(_G, "CharacterFrameBg")
    HideElement(_G, "CharacterFrameTitleBg")

    -- Hide inset
    local CharacterFrameInset = CharacterFrame.Inset or _G.CharacterFrameInset
    if CharacterFrameInset then
        StripTextures(CharacterFrameInset)
        if CharacterFrameInset.NineSlice then
            StripTextures(CharacterFrameInset.NineSlice)
            CharacterFrameInset.NineSlice:Hide()
        end
        HideElement(CharacterFrameInset, "Bg")
    end

    -- Strip textures from main frame BUT preserve children like tabs
    for i = 1, CharacterFrame:GetNumRegions() do
        local region = select(i, CharacterFrame:GetRegions())
        if region and region:IsObjectType("Texture") then
            region:SetTexture("")
            region:SetAlpha(0)
            region:Hide()
        end
    end

    -- Apply Aurora backdrop to main frame
    Base.SetBackdrop(CharacterFrame, Color.frame)

    -- Skin close button
    local closeButton = CharacterFrame.CloseButton or _G.CharacterFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin tabs (Character, Pet, Reputation, Skills, PvP) with proper positioning
    for i = 1, 5 do
        local tab = _G["CharacterFrameTab"..i]
        SkinTab(tab, i)
    end

    -- Make title text readable (white)
    local titleText = _G.CharacterFrameTitleText or CharacterFrame.TitleText
    if titleText then
        titleText:SetTextColor(1, 1, 1)
    end

    -- Strip textures from sub-panels (these have the ornate background textures)
    -- NOTE: This strips panel backgrounds, NOT equipment slot icons
    -- Equipment slot icons are handled separately in PaperDollFrame.lua
    local panels = {
        "PaperDollFrame",
        "ReputationFrame",
        "SkillFrame",
        "PetPaperDollFrame"
    }
    for _, panelName in ipairs(panels) do
        local panel = _G[panelName]
        if panel then
            StripTextures(panel)
        end
    end

    -- Specifically handle HonorFrame (PvP tab) with extra texture removal
    local HonorFrame = _G.HonorFrame
    if HonorFrame then
        StripTextures(HonorFrame)
        -- Hide specific PvP textures
        HideElement(_G, "HonorFramePortrait")
        HideElement(_G, "HonorFrameBackground")
        HideElement(_G, "HonorFrameBadge")
        HideElement(_G, "HonorFrameRankIcon")
        HideElement(_G, "HonorFrameStatsBgLeft")
        HideElement(_G, "HonorFrameStatsBgRight")
        HideElement(_G, "HonorFrameStatsBgTop")
        HideElement(_G, "HonorFrameStatsBgBottom")

        -- Hide any NineSlice on HonorFrame
        if HonorFrame.NineSlice then
            StripTextures(HonorFrame.NineSlice)
            HonorFrame.NineSlice:Hide()
        end

        -- Make PvP text readable
        for i = 1, HonorFrame:GetNumRegions() do
            local region = select(i, HonorFrame:GetRegions())
            if region and region:IsObjectType("FontString") then
                local r, g, b = region:GetTextColor()
                -- If text is too dark, make it lighter
                if r < 0.5 and g < 0.5 and b < 0.5 then
                    region:SetTextColor(0.9, 0.9, 0.9)
                end
            end
        end
    end
end
