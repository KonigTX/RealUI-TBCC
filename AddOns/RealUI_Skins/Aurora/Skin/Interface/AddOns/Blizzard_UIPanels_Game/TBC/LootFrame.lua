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

function private.FrameXML.LootFrame()
    local LootFrame = _G.LootFrame
    if not LootFrame then return end

    -- Hide NineSlice border system (TBCC uses this)
    if LootFrame.NineSlice then
        StripTextures(LootFrame.NineSlice)
        LootFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(LootFrame, "portrait")
    HideElement(LootFrame, "PortraitFrame")
    HideElement(LootFrame, "PortraitContainer")
    HideElement(_G, "LootFramePortrait")
    HideElement(_G, "LootFramePortraitFrame")

    -- Hide border edges (TBCC structure)
    HideElement(LootFrame, "TopEdge")
    HideElement(LootFrame, "BottomEdge")
    HideElement(LootFrame, "LeftEdge")
    HideElement(LootFrame, "RightEdge")
    HideElement(LootFrame, "TopLeftCorner")
    HideElement(LootFrame, "TopRightCorner")
    HideElement(LootFrame, "BottomLeftCorner")
    HideElement(LootFrame, "BottomRightCorner")
    HideElement(LootFrame, "Center")

    -- Hide named global textures (fallback)
    HideElement(_G, "LootFrameTopLeftCorner")
    HideElement(_G, "LootFrameTopRightCorner")
    HideElement(_G, "LootFrameBottomLeftCorner")
    HideElement(_G, "LootFrameBottomRightCorner")
    HideElement(_G, "LootFrameTopBorder")
    HideElement(_G, "LootFrameBottomBorder")
    HideElement(_G, "LootFrameLeftBorder")
    HideElement(_G, "LootFrameRightBorder")

    -- Hide Bg and TitleBg
    HideElement(LootFrame, "Bg")
    HideElement(LootFrame, "TitleBg")
    HideElement(_G, "LootFrameBg")
    HideElement(_G, "LootFrameTitleBg")

    -- Hide inset
    local LootFrameInset = LootFrame.Inset or _G.LootFrameInset
    if LootFrameInset then
        StripTextures(LootFrameInset)
        if LootFrameInset.NineSlice then
            StripTextures(LootFrameInset.NineSlice)
            LootFrameInset.NineSlice:Hide()
        end
        HideElement(LootFrameInset, "Bg")
    end

    -- Strip ALL textures from main frame
    StripTextures(LootFrame)

    -- Apply Aurora backdrop to main frame
    Base.SetBackdrop(LootFrame, Color.frame)

    -- Skin close button
    local closeButton = LootFrame.CloseButton or _G.LootFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin loot buttons (dynamically created)
    for i = 1, 4 do
        local lootButton = _G["LootButton"..i]
        if lootButton then
            Skin.FrameTypeButton(lootButton)
        end
    end
end
