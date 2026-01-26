local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select

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

-- MacroFrame is created by Blizzard_MacroUI (load-on-demand)
-- Register as AddOn skin instead of FrameXML
private.AddOns["Blizzard_MacroUI"] = function()
    local MacroFrame = _G.MacroFrame
    if not MacroFrame then return end

    -- Hide NineSlice border system (TBCC uses this)
    if MacroFrame.NineSlice then
        StripTextures(MacroFrame.NineSlice)
        MacroFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(MacroFrame, "portrait")
    HideElement(MacroFrame, "PortraitFrame")
    HideElement(MacroFrame, "PortraitContainer")
    HideElement(_G, "MacroFramePortrait")
    HideElement(_G, "MacroFramePortraitFrame")

    -- Hide border edges (TBCC structure)
    HideElement(MacroFrame, "TopEdge")
    HideElement(MacroFrame, "BottomEdge")
    HideElement(MacroFrame, "LeftEdge")
    HideElement(MacroFrame, "RightEdge")
    HideElement(MacroFrame, "TopLeftCorner")
    HideElement(MacroFrame, "TopRightCorner")
    HideElement(MacroFrame, "BottomLeftCorner")
    HideElement(MacroFrame, "BottomRightCorner")
    HideElement(MacroFrame, "Center")

    -- Hide named global textures (fallback)
    HideElement(_G, "MacroFrameTopLeftCorner")
    HideElement(_G, "MacroFrameTopRightCorner")
    HideElement(_G, "MacroFrameBottomLeftCorner")
    HideElement(_G, "MacroFrameBottomRightCorner")
    HideElement(_G, "MacroFrameTopBorder")
    HideElement(_G, "MacroFrameBottomBorder")
    HideElement(_G, "MacroFrameLeftBorder")
    HideElement(_G, "MacroFrameRightBorder")

    -- Hide Bg and TitleBg
    HideElement(MacroFrame, "Bg")
    HideElement(MacroFrame, "TitleBg")
    HideElement(_G, "MacroFrameBg")
    HideElement(_G, "MacroFrameTitleBg")

    -- Hide inset
    local MacroFrameInset = MacroFrame.Inset or _G.MacroFrameInset
    if MacroFrameInset then
        StripTextures(MacroFrameInset)
        if MacroFrameInset.NineSlice then
            StripTextures(MacroFrameInset.NineSlice)
            MacroFrameInset.NineSlice:Hide()
        end
        HideElement(MacroFrameInset, "Bg")
    end

    -- Strip ALL textures from main frame
    StripTextures(MacroFrame)

    -- Apply Aurora backdrop to main frame
    Base.SetBackdrop(MacroFrame, Color.frame)

    -- Skin close button
    local closeButton = MacroFrame.CloseButton or _G.MacroFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin tabs
    for i = 1, 2 do
        local tab = _G["MacroFrameTab"..i]
        if tab then
            StripTextures(tab)
            Skin.FrameTypeButton(tab)
        end
    end

    -- Skin action buttons
    local MacroNewButton = _G.MacroNewButton
    if MacroNewButton then
        Skin.FrameTypeButton(MacroNewButton)
    end

    local MacroDeleteButton = _G.MacroDeleteButton
    if MacroDeleteButton then
        Skin.FrameTypeButton(MacroDeleteButton)
    end

    local MacroSaveButton = _G.MacroSaveButton
    if MacroSaveButton then
        Skin.FrameTypeButton(MacroSaveButton)
    end

    local MacroCancelButton = _G.MacroCancelButton
    if MacroCancelButton then
        Skin.FrameTypeButton(MacroCancelButton)
    end

    local MacroEditButton = _G.MacroEditButton
    if MacroEditButton then
        Skin.FrameTypeButton(MacroEditButton)
    end

    local MacroExitButton = _G.MacroExitButton
    if MacroExitButton then
        Skin.FrameTypeButton(MacroExitButton)
    end

    -- Skin scroll frame
    local MacroFrameScrollFrame = _G.MacroFrameScrollFrame
    if MacroFrameScrollFrame then
        Base.SetBackdrop(MacroFrameScrollFrame, Color.frame, 0.3)
    end

    -- Skin text background
    local MacroFrameTextBackground = _G.MacroFrameTextBackground
    if MacroFrameTextBackground then
        Base.SetBackdrop(MacroFrameTextBackground, Color.frame, 0.3)
    end
end
