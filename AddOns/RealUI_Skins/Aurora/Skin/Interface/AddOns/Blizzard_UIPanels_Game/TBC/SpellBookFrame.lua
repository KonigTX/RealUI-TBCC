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

function private.FrameXML.SpellBookFrame()
    local SpellBookFrame = _G.SpellBookFrame
    if not SpellBookFrame then return end

    -- Hide NineSlice border system (TBCC uses this)
    if SpellBookFrame.NineSlice then
        StripTextures(SpellBookFrame.NineSlice)
        SpellBookFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(SpellBookFrame, "portrait")
    HideElement(SpellBookFrame, "PortraitFrame")
    HideElement(SpellBookFrame, "PortraitContainer")
    HideElement(_G, "SpellBookFramePortrait")
    HideElement(_G, "SpellBookFramePortraitFrame")

    -- Hide border edges (TBCC structure)
    HideElement(SpellBookFrame, "TopEdge")
    HideElement(SpellBookFrame, "BottomEdge")
    HideElement(SpellBookFrame, "LeftEdge")
    HideElement(SpellBookFrame, "RightEdge")
    HideElement(SpellBookFrame, "TopLeftCorner")
    HideElement(SpellBookFrame, "TopRightCorner")
    HideElement(SpellBookFrame, "BottomLeftCorner")
    HideElement(SpellBookFrame, "BottomRightCorner")
    HideElement(SpellBookFrame, "Center")

    -- Hide named global textures (fallback)
    HideElement(_G, "SpellBookFrameTopLeftCorner")
    HideElement(_G, "SpellBookFrameTopRightCorner")
    HideElement(_G, "SpellBookFrameBottomLeftCorner")
    HideElement(_G, "SpellBookFrameBottomRightCorner")
    HideElement(_G, "SpellBookFrameTopBorder")
    HideElement(_G, "SpellBookFrameBottomBorder")
    HideElement(_G, "SpellBookFrameLeftBorder")
    HideElement(_G, "SpellBookFrameRightBorder")
    HideElement(_G, "SpellBookFrameBackground")

    -- Hide Bg and TitleBg
    HideElement(SpellBookFrame, "Bg")
    HideElement(SpellBookFrame, "TitleBg")
    HideElement(_G, "SpellBookFrameBg")
    HideElement(_G, "SpellBookFrameTitleBg")

    -- Hide inset
    local SpellBookFrameInset = SpellBookFrame.Inset or _G.SpellBookFrameInset
    if SpellBookFrameInset then
        StripTextures(SpellBookFrameInset)
        if SpellBookFrameInset.NineSlice then
            StripTextures(SpellBookFrameInset.NineSlice)
            SpellBookFrameInset.NineSlice:Hide()
        end
        HideElement(SpellBookFrameInset, "Bg")
    end

    -- Strip ALL textures from main frame
    StripTextures(SpellBookFrame)

    -- Apply Aurora backdrop to main frame
    Base.SetBackdrop(SpellBookFrame, Color.frame)

    -- Skin close button
    local closeButton = SpellBookFrame.CloseButton or _G.SpellBookFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin main tabs
    for i = 1, 3 do
        local tab = _G["SpellBookFrameTabButton"..i]
        if tab then
            StripTextures(tab)
            Skin.FrameTypeButton(tab)
        end
    end

    -- Skin skill line tabs (profession tabs on the side)
    for i = 1, 8 do
        local skillTab = _G["SpellBookSkillLineTab"..i]
        if skillTab then
            StripTextures(skillTab)
            Skin.FrameTypeButton(skillTab)
        end
    end

    -- Skin page navigation buttons
    local SpellBookPrevPageButton = _G.SpellBookPrevPageButton
    if SpellBookPrevPageButton then
        Skin.FrameTypeButton(SpellBookPrevPageButton)
    end

    local SpellBookNextPageButton = _G.SpellBookNextPageButton
    if SpellBookNextPageButton then
        Skin.FrameTypeButton(SpellBookNextPageButton)
    end
end
