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

function private.FrameXML.MailFrame()
    local MailFrame = _G.MailFrame
    if not MailFrame then return end

    -- Hide NineSlice border system (TBCC uses this)
    if MailFrame.NineSlice then
        StripTextures(MailFrame.NineSlice)
        MailFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(MailFrame, "portrait")
    HideElement(MailFrame, "PortraitFrame")
    HideElement(MailFrame, "PortraitContainer")
    HideElement(_G, "MailFramePortrait")
    HideElement(_G, "MailFramePortraitFrame")

    -- Hide border edges (TBCC structure)
    HideElement(MailFrame, "TopEdge")
    HideElement(MailFrame, "BottomEdge")
    HideElement(MailFrame, "LeftEdge")
    HideElement(MailFrame, "RightEdge")
    HideElement(MailFrame, "TopLeftCorner")
    HideElement(MailFrame, "TopRightCorner")
    HideElement(MailFrame, "BottomLeftCorner")
    HideElement(MailFrame, "BottomRightCorner")
    HideElement(MailFrame, "Center")

    -- Hide named global textures (fallback)
    HideElement(_G, "MailFrameTopLeftCorner")
    HideElement(_G, "MailFrameTopRightCorner")
    HideElement(_G, "MailFrameBottomLeftCorner")
    HideElement(_G, "MailFrameBottomRightCorner")
    HideElement(_G, "MailFrameTopBorder")
    HideElement(_G, "MailFrameBottomBorder")
    HideElement(_G, "MailFrameLeftBorder")
    HideElement(_G, "MailFrameRightBorder")

    -- Hide Bg and TitleBg
    HideElement(MailFrame, "Bg")
    HideElement(MailFrame, "TitleBg")
    HideElement(_G, "MailFrameBg")
    HideElement(_G, "MailFrameTitleBg")

    -- Hide inset
    local MailFrameInset = MailFrame.Inset or _G.MailFrameInset
    if MailFrameInset then
        StripTextures(MailFrameInset)
        if MailFrameInset.NineSlice then
            StripTextures(MailFrameInset.NineSlice)
            MailFrameInset.NineSlice:Hide()
        end
        HideElement(MailFrameInset, "Bg")
    end

    -- Strip ALL textures from main frame
    StripTextures(MailFrame)

    -- Apply Aurora backdrop to main frame
    Base.SetBackdrop(MailFrame, Color.frame)

    -- Skin close button
    local closeButton = MailFrame.CloseButton or _G.MailFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin tabs
    for i = 1, 2 do
        local tab = _G["MailFrameTab"..i]
        if tab then
            StripTextures(tab)
            Skin.FrameTypeButton(tab)
        end
    end

    -- Skin OpenMailFrame
    local OpenMailFrame = _G.OpenMailFrame
    if OpenMailFrame then
        StripTextures(OpenMailFrame)
        Base.SetBackdrop(OpenMailFrame, Color.frame)

        local openCloseButton = OpenMailFrame.CloseButton or _G.OpenMailFrameCloseButton
        if openCloseButton then
            Skin.FrameTypeButton(openCloseButton)
        end

        local OpenMailReplyButton = _G.OpenMailReplyButton
        if OpenMailReplyButton then
            Skin.FrameTypeButton(OpenMailReplyButton)
        end

        local OpenMailDeleteButton = _G.OpenMailDeleteButton
        if OpenMailDeleteButton then
            Skin.FrameTypeButton(OpenMailDeleteButton)
        end
    end

    -- Skin SendMailFrame
    local SendMailFrame = _G.SendMailFrame
    if SendMailFrame then
        local SendMailMailButton = _G.SendMailMailButton
        if SendMailMailButton then
            Skin.FrameTypeButton(SendMailMailButton)
        end

        local SendMailCancelButton = _G.SendMailCancelButton
        if SendMailCancelButton then
            Skin.FrameTypeButton(SendMailCancelButton)
        end
    end
end
