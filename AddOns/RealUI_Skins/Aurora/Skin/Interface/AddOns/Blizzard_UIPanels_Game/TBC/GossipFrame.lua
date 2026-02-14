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
    local borderElements = {
        "TopEdge", "BottomEdge", "LeftEdge", "RightEdge",
        "TopLeftCorner", "TopRightCorner", "BottomLeftCorner", "BottomRightCorner",
        "Center", "TopBorder", "BottomBorder", "LeftBorder", "RightBorder",
        "BotLeftCorner", "BotRightCorner"
    }
    for _, name in ipairs(borderElements) do
        HideElement(GossipFrame, name)
    end

    -- Hide named global textures
    local globalTextures = {
        "GossipFrameTopLeftCorner", "GossipFrameTopRightCorner",
        "GossipFrameBottomLeftCorner", "GossipFrameBottomRightCorner",
        "GossipFrameTopBorder", "GossipFrameBottomBorder",
        "GossipFrameLeftBorder", "GossipFrameRightBorder",
        "GossipFrameTopTileStreaks", "GossipFrameBg", "GossipFrameTitleBg"
    }
    for _, name in ipairs(globalTextures) do
        HideElement(_G, name)
    end

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

    -- Strip textures from main frame (but be careful not to hide everything)
    StripTextures(GossipFrame)

    -- Apply Aurora backdrop
    Base.SetBackdrop(GossipFrame, Color.frame)

    -- Skin close button with TBC-compatible X
    local closeButton = GossipFrame.CloseButton or _G.GossipFrameCloseButton
    if closeButton then
        if Skin.UIPanelCloseButton then
            Skin.UIPanelCloseButton(closeButton)
        else
            Skin.FrameTypeButton(closeButton)
        end
    end

    -- Skin greeting scroll frame
    local GossipGreetingScrollFrame = _G.GossipGreetingScrollFrame
    if GossipGreetingScrollFrame then
        StripTextures(GossipGreetingScrollFrame)

        -- Skin the scrollbar
        local scrollBar = _G.GossipGreetingScrollFrameScrollBar
        if scrollBar and Skin.UIPanelScrollBarTBC then
            Skin.UIPanelScrollBarTBC(scrollBar)
        end
    end

    -- Skin goodbye button
    local GossipFrameGreetingGoodbyeButton = _G.GossipFrameGreetingGoodbyeButton
    if GossipFrameGreetingGoodbyeButton then
        Skin.FrameTypeButton(GossipFrameGreetingGoodbyeButton)
    end

    -- Skin gossip option buttons
    local function SkinGossipButtons()
        for i = 1, _G.NUMGOSSIPBUTTONS or 32 do
            local button = _G["GossipTitleButton"..i]
            if button and not button._auroraSkinned then
                -- Don't use FrameTypeButton - it strips textures we might need
                -- Just ensure the text is readable
                button._auroraSkinned = true
            end
        end
    end

    SkinGossipButtons()

    -- Hook GossipFrameUpdate if it exists
    if _G.GossipFrameUpdate then
        hooksecurefunc("GossipFrameUpdate", SkinGossipButtons)
    end

    -- =============================================================================
    -- Text Recoloring
    -- =============================================================================
    local function RecolorGossipText()
        -- NPC name/title
        local titleText = _G.GossipFrameNpcNameText or _G.GossipFrameTitleText
        if titleText and titleText.SetTextColor then
            titleText:SetTextColor(1, 1, 1)
        end

        -- Greeting text
        local greetingText = _G.GossipGreetingText
        if greetingText and greetingText.SetTextColor then
            greetingText:SetTextColor(1, 1, 1)
        end

        -- Option buttons text
        for i = 1, _G.NUMGOSSIPBUTTONS or 32 do
            local button = _G["GossipTitleButton"..i]
            if button and button:IsShown() then
                -- Get the text child
                local buttonText = button.GossipText or button:GetFontString()
                if buttonText and buttonText.SetTextColor then
                    buttonText:SetTextColor(1, 1, 1)
                end

                -- Also check all regions
                for j = 1, button:GetNumRegions() do
                    local region = select(j, button:GetRegions())
                    if region and region:IsObjectType("FontString") then
                        region:SetTextColor(1, 1, 1)
                    end
                end

                -- Add number indicator
                if not button._auroraNumberLabel then
                    button._auroraNumberLabel = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
                    button._auroraNumberLabel:SetPoint("LEFT", button, "LEFT", 5, 0)
                    button._auroraNumberLabel:SetTextColor(1, 0.82, 0)
                end
                button._auroraNumberLabel:SetText(i .. ".")
                button._auroraNumberLabel:Show()
            elseif button and button._auroraNumberLabel then
                button._auroraNumberLabel:Hide()
            end
        end

        -- Scroll child content
        local GossipGreetingScrollFrame = _G.GossipGreetingScrollFrame
        if GossipGreetingScrollFrame then
            local scrollChild = GossipGreetingScrollFrame:GetScrollChild()
            if scrollChild then
                for i = 1, scrollChild:GetNumRegions() do
                    local region = select(i, scrollChild:GetRegions())
                    if region and region:IsObjectType("FontString") then
                        region:SetTextColor(1, 1, 1)
                    end
                end
            end
        end
    end

    -- Hook updates - apply text recoloring directly without delay
    if _G.GossipFrameUpdate then
        hooksecurefunc("GossipFrameUpdate", RecolorGossipText)
    end

    GossipFrame:HookScript("OnShow", RecolorGossipText)
    RecolorGossipText()
end
