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

function private.FrameXML.BankFrame()
    local BankFrame = _G.BankFrame
    if not BankFrame then return end

    -- Hide NineSlice border system (TBCC uses this)
    if BankFrame.NineSlice then
        StripTextures(BankFrame.NineSlice)
        BankFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(BankFrame, "portrait")
    HideElement(BankFrame, "PortraitFrame")
    HideElement(BankFrame, "PortraitContainer")
    HideElement(_G, "BankFramePortrait")
    HideElement(_G, "BankFramePortraitFrame")

    -- Hide border edges (TBCC structure)
    HideElement(BankFrame, "TopEdge")
    HideElement(BankFrame, "BottomEdge")
    HideElement(BankFrame, "LeftEdge")
    HideElement(BankFrame, "RightEdge")
    HideElement(BankFrame, "TopLeftCorner")
    HideElement(BankFrame, "TopRightCorner")
    HideElement(BankFrame, "BottomLeftCorner")
    HideElement(BankFrame, "BottomRightCorner")
    HideElement(BankFrame, "Center")

    -- Hide named global textures (fallback)
    HideElement(_G, "BankFrameTopLeftCorner")
    HideElement(_G, "BankFrameTopRightCorner")
    HideElement(_G, "BankFrameBottomLeftCorner")
    HideElement(_G, "BankFrameBottomRightCorner")
    HideElement(_G, "BankFrameTopBorder")
    HideElement(_G, "BankFrameBottomBorder")
    HideElement(_G, "BankFrameLeftBorder")
    HideElement(_G, "BankFrameRightBorder")

    -- Hide Bg and TitleBg
    HideElement(BankFrame, "Bg")
    HideElement(BankFrame, "TitleBg")
    HideElement(_G, "BankFrameBg")
    HideElement(_G, "BankFrameTitleBg")

    -- Hide inset
    local BankFrameInset = BankFrame.Inset or _G.BankFrameInset
    if BankFrameInset then
        StripTextures(BankFrameInset)
        if BankFrameInset.NineSlice then
            StripTextures(BankFrameInset.NineSlice)
            BankFrameInset.NineSlice:Hide()
        end
        HideElement(BankFrameInset, "Bg")
    end

    -- Strip ALL textures from main frame
    StripTextures(BankFrame)

    -- Apply Aurora backdrop to main frame
    Base.SetBackdrop(BankFrame, Color.frame)

    -- Skin close button
    local closeButton = BankFrame.CloseButton or _G.BankFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin purchase button
    local BankFramePurchaseButton = _G.BankFramePurchaseButton
    if BankFramePurchaseButton then
        Skin.FrameTypeButton(BankFramePurchaseButton)
    end

    -- Skin bank item slots
    for i = 1, 28 do
        local item = _G["BankFrameItem"..i]
        if item then
            Skin.FrameTypeButton(item)
        end
    end

    -- Skin bank bag slots
    for i = 1, 7 do
        local bag = _G["BankFrameBag"..i]
        if bag then
            Skin.FrameTypeButton(bag)
        end
    end
end
