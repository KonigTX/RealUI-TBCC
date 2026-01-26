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

-- InspectFrame is created by Blizzard_InspectUI (load-on-demand)
-- Register as AddOn skin instead of FrameXML
private.AddOns["Blizzard_InspectUI"] = function()
    local InspectFrame = _G.InspectFrame
    if not InspectFrame then return end

    -- Hide NineSlice border system (TBCC uses this)
    if InspectFrame.NineSlice then
        StripTextures(InspectFrame.NineSlice)
        InspectFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(InspectFrame, "portrait")
    HideElement(InspectFrame, "PortraitFrame")
    HideElement(InspectFrame, "PortraitContainer")
    HideElement(_G, "InspectFramePortrait")
    HideElement(_G, "InspectFramePortraitFrame")

    -- Hide border edges (TBCC structure)
    HideElement(InspectFrame, "TopEdge")
    HideElement(InspectFrame, "BottomEdge")
    HideElement(InspectFrame, "LeftEdge")
    HideElement(InspectFrame, "RightEdge")
    HideElement(InspectFrame, "TopLeftCorner")
    HideElement(InspectFrame, "TopRightCorner")
    HideElement(InspectFrame, "BottomLeftCorner")
    HideElement(InspectFrame, "BottomRightCorner")
    HideElement(InspectFrame, "Center")

    -- Hide named global textures (fallback)
    HideElement(_G, "InspectFrameTopLeftCorner")
    HideElement(_G, "InspectFrameTopRightCorner")
    HideElement(_G, "InspectFrameBottomLeftCorner")
    HideElement(_G, "InspectFrameBottomRightCorner")
    HideElement(_G, "InspectFrameTopBorder")
    HideElement(_G, "InspectFrameBottomBorder")
    HideElement(_G, "InspectFrameLeftBorder")
    HideElement(_G, "InspectFrameRightBorder")

    -- Hide Bg and TitleBg
    HideElement(InspectFrame, "Bg")
    HideElement(InspectFrame, "TitleBg")
    HideElement(_G, "InspectFrameBg")
    HideElement(_G, "InspectFrameTitleBg")

    -- Hide inset
    local InspectFrameInset = InspectFrame.Inset or _G.InspectFrameInset
    if InspectFrameInset then
        StripTextures(InspectFrameInset)
        if InspectFrameInset.NineSlice then
            StripTextures(InspectFrameInset.NineSlice)
            InspectFrameInset.NineSlice:Hide()
        end
        HideElement(InspectFrameInset, "Bg")
    end

    -- Strip ALL textures from main frame
    StripTextures(InspectFrame)

    -- Apply Aurora backdrop to main frame
    Base.SetBackdrop(InspectFrame, Color.frame)

    -- Skin close button
    local closeButton = InspectFrame.CloseButton or _G.InspectFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin tabs (Character, Honor)
    for i = 1, 2 do
        local tab = _G["InspectFrameTab"..i]
        if tab then
            StripTextures(tab)
            Skin.FrameTypeButton(tab)
        end
    end

    -- Skin equipment slots
    local slotNames = {
        "Head", "Neck", "Shoulder", "Back", "Chest", "Shirt", "Tabard",
        "Wrist", "Hands", "Waist", "Legs", "Feet",
        "Finger0", "Finger1", "Trinket0", "Trinket1",
        "MainHand", "SecondaryHand", "Ranged"
    }

    for _, slotName in ipairs(slotNames) do
        local slot = _G["Inspect"..slotName.."Slot"]
        if slot then
            Skin.FrameTypeButton(slot)
            if slot.icon then
                slot.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92)
            end
        end
    end

    -- Hide model frame background
    local InspectModelFrame = _G.InspectModelFrame
    if InspectModelFrame then
        StripTextures(InspectModelFrame)
    end
end
