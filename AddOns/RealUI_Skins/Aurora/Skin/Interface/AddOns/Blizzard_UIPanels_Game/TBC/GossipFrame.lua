local _, private = ...
if not private.isTBC then return end

--[[ Lua Globals ]]
-- luacheck: globals select hooksecurefunc

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

function private.FrameXML.GossipFrame()
    local GossipFrame = _G.GossipFrame
    if not GossipFrame then return end

    -- Hide NineSlice border system
    if GossipFrame.NineSlice then
        StripTextures(GossipFrame.NineSlice)
        GossipFrame.NineSlice:Hide()
    end

    -- Hide portrait and portrait frame
    HideElement(GossipFrame, "portrait")
    HideElement(GossipFrame, "PortraitFrame")
    HideElement(GossipFrame, "PortraitContainer")
    HideElement(_G, "GossipFramePortrait")
    HideElement(_G, "GossipFramePortraitFrame")

    -- Hide border edges
    HideElement(GossipFrame, "TopEdge")
    HideElement(GossipFrame, "BottomEdge")
    HideElement(GossipFrame, "LeftEdge")
    HideElement(GossipFrame, "RightEdge")
    HideElement(GossipFrame, "TopLeftCorner")
    HideElement(GossipFrame, "TopRightCorner")
    HideElement(GossipFrame, "BottomLeftCorner")
    HideElement(GossipFrame, "BottomRightCorner")
    HideElement(GossipFrame, "Center")

    -- Hide border regions
    HideElement(GossipFrame, "TopBorder")
    HideElement(GossipFrame, "BottomBorder")
    HideElement(GossipFrame, "LeftBorder")
    HideElement(GossipFrame, "RightBorder")
    HideElement(GossipFrame, "BotLeftCorner")
    HideElement(GossipFrame, "BotRightCorner")

    -- Hide named global textures
    HideElement(_G, "GossipFrameTopLeftCorner")
    HideElement(_G, "GossipFrameTopRightCorner")
    HideElement(_G, "GossipFrameBottomLeftCorner")
    HideElement(_G, "GossipFrameBottomRightCorner")
    HideElement(_G, "GossipFrameTopBorder")
    HideElement(_G, "GossipFrameBottomBorder")
    HideElement(_G, "GossipFrameLeftBorder")
    HideElement(_G, "GossipFrameRightBorder")
    HideElement(_G, "GossipFrameTopTileStreaks")

    -- Hide Bg and TitleBg
    HideElement(GossipFrame, "Bg")
    HideElement(GossipFrame, "TitleBg")

    -- Hide inset
    local GossipFrameInset = GossipFrame.Inset or _G.GossipFrameInset
    if GossipFrameInset then
        StripTextures(GossipFrameInset)
        if GossipFrameInset.NineSlice then
            StripTextures(GossipFrameInset.NineSlice)
            GossipFrameInset.NineSlice:Hide()
        end
        HideElement(GossipFrameInset, "Bg")
    end

    -- Hide GreetingPanel
    if GossipFrame.GreetingPanel then
        StripTextures(GossipFrame.GreetingPanel)
    end

    -- Strip ALL textures from main frame
    StripTextures(GossipFrame)

    -- Apply Aurora backdrop
    Base.SetBackdrop(GossipFrame, Color.frame)

    -- Skin close button
    local closeButton = GossipFrame.CloseButton or _G.GossipFrameCloseButton
    if closeButton then
        Skin.FrameTypeButton(closeButton)
    end

    -- Skin greeting scroll frame (if it exists)
    local GossipGreetingScrollFrame = _G.GossipGreetingScrollFrame
    if GossipGreetingScrollFrame then
        StripTextures(GossipGreetingScrollFrame)
        Base.SetBackdrop(GossipGreetingScrollFrame, Color.frame, 0.3)
    end

    -- Skin gossip option buttons (skin existing ones immediately)
    for i = 1, _G.NUMGOSSIPBUTTONS or 32 do
        local button = _G["GossipTitleButton"..i]
        if button and not button._auroraSkinned then
            Skin.FrameTypeButton(button)
            button._auroraSkinned = true
        end
    end

    -- Hook GossipFrameUpdate if it exists (may not in all TBCC versions)
    if _G.GossipFrameUpdate then
        hooksecurefunc("GossipFrameUpdate", function()
            for i = 1, _G.NUMGOSSIPBUTTONS or 32 do
                local button = _G["GossipTitleButton"..i]
                if button and not button._auroraSkinned then
                    Skin.FrameTypeButton(button)
                    button._auroraSkinned = true
                end
            end
        end)
    end

    -- Skin goodbye button
    local GossipFrameGreetingGoodbyeButton = _G.GossipFrameGreetingGoodbyeButton
    if GossipFrameGreetingGoodbyeButton then
        Skin.FrameTypeButton(GossipFrameGreetingGoodbyeButton)
    end
end
