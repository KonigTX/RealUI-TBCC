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

function private.FrameXML.MerchantFrame()
    local MerchantFrame = _G.MerchantFrame
    if not MerchantFrame then return end

    -- Hide NineSlice border system (TBCC uses this)
    if MerchantFrame.NineSlice then
        StripTextures(MerchantFrame.NineSlice)
        MerchantFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(MerchantFrame, "portrait")
    HideElement(MerchantFrame, "PortraitFrame")
    HideElement(MerchantFrame, "PortraitContainer")
    HideElement(_G, "MerchantFramePortrait")
    HideElement(_G, "MerchantFramePortraitFrame")

    -- Hide border edges (TBCC structure)
    HideElement(MerchantFrame, "TopEdge")
    HideElement(MerchantFrame, "BottomEdge")
    HideElement(MerchantFrame, "LeftEdge")
    HideElement(MerchantFrame, "RightEdge")
    HideElement(MerchantFrame, "TopLeftCorner")
    HideElement(MerchantFrame, "TopRightCorner")
    HideElement(MerchantFrame, "BottomLeftCorner")
    HideElement(MerchantFrame, "BottomRightCorner")
    HideElement(MerchantFrame, "Center")

    -- Hide named global textures (fallback)
    HideElement(_G, "MerchantFrameTopLeftCorner")
    HideElement(_G, "MerchantFrameTopRightCorner")
    HideElement(_G, "MerchantFrameBottomLeftCorner")
    HideElement(_G, "MerchantFrameBottomRightCorner")
    HideElement(_G, "MerchantFrameTopBorder")
    HideElement(_G, "MerchantFrameBottomBorder")
    HideElement(_G, "MerchantFrameLeftBorder")
    HideElement(_G, "MerchantFrameRightBorder")

    -- Hide Bg and TitleBg
    HideElement(MerchantFrame, "Bg")
    HideElement(MerchantFrame, "TitleBg")
    HideElement(_G, "MerchantFrameBg")
    HideElement(_G, "MerchantFrameTitleBg")

    -- Hide inset
    local MerchantFrameInset = MerchantFrame.Inset or _G.MerchantFrameInset
    if MerchantFrameInset then
        StripTextures(MerchantFrameInset)
        if MerchantFrameInset.NineSlice then
            StripTextures(MerchantFrameInset.NineSlice)
            MerchantFrameInset.NineSlice:Hide()
        end
        HideElement(MerchantFrameInset, "Bg")
    end

    -- Strip ALL textures from main frame
    StripTextures(MerchantFrame)

    -- Apply Aurora backdrop to main frame
    Base.SetBackdrop(MerchantFrame, Color.frame)

    -- Skin close button
    local closeButton = MerchantFrame.CloseButton or _G.MerchantFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin tabs if present
    for i = 1, 2 do
        local tab = _G["MerchantFrameTab"..i]
        if tab then
            StripTextures(tab)
            Skin.FrameTypeButton(tab)
        end
    end

    -- Skin repair button
    local MerchantRepairAllButton = _G.MerchantRepairAllButton
    if MerchantRepairAllButton then
        Skin.FrameTypeButton(MerchantRepairAllButton)
    end

    -- Skin buyback button
    local MerchantBuyBackButton = _G.MerchantBuyBackButton
    if MerchantBuyBackButton then
        Skin.FrameTypeButton(MerchantBuyBackButton)
    end

    -- Skin scroll frame
    local MerchantFrameScrollFrame = _G.MerchantFrameScrollFrame
    if MerchantFrameScrollFrame then
        Base.SetBackdrop(MerchantFrameScrollFrame, Color.frame, 0.3)
    end
end
